<?php

namespace BDTheque\Support;


use SimpleXMLElement;

class ISBN
{
    /**
     * @param string $isbn
     * @return string
     */
    static public function format(string $isbn): string
    {
        $isbn = self::cleanISBN($isbn);
        $isbn = substr($isbn, 0, min(strlen($isbn), 13));
        $s = $isbn;
        if (strlen($s) > 10) {
            $isbn_agency = substr($s, 0, 3);
            $s = substr($s, 3, min(strlen($s), 13));
        } else
            $isbn_agency = '978';

        if (strlen($s) < 10) return $isbn;

        self::decodeISBNRules();

        $group_size = self::getLengthForPrefix(self::$isbnPrefixes, $isbn_agency, intval(substr($s, 0, 7)), 1);
        $group = substr($s, 0, $group_size);

        $publisher_size = self::getLengthForPrefix(self::$isbnGroups, $isbn_agency . '-' . $group, substr($s, $group_size, 7), 2);
        $publisher = substr($s, $group_size, $publisher_size);

        return
            (strlen($isbn) > 10 ? $isbn_agency . '-' : '')
            . $group
            . '-'
            . $publisher
            . '-'
            . substr($s, $group_size + $publisher_size, 9 - $group_size - $publisher_size)
            . '-'
            . substr($s, -1);
    }

    /**
     * @param string $isbn
     * @return string
     */
    static private function cleanISBN(string $isbn): string
    {
        $result = '';
        foreach (str_split(strtoupper($isbn)) as $c)
            if (strpos('0123456789X', $c) !== false)
                $result .= $c;
        return $result;
    }

    static public $isbnPrefixes;
    static public $isbnGroups;

    /**
     *
     */
    static public function decodeISBNRules()
    {
        if (self::$isbnPrefixes) return;

        /**
         * @param SimpleXMLElement $node
         * @param string $listNodeName
         * @return array
         */
        $loadNode = function (SimpleXMLElement $node, string $listNodeName) {
            $map = [];
            foreach ($node->children() as $xmlPrefix)
                if ($xmlPrefix->getName() == $listNodeName) {
                    $prefix = $xmlPrefix->{'Prefix'}->__toString();
                    $rules = [];
                    foreach ($xmlPrefix->{'Rules'}->children() as $xmlRule) {
                        $range = $xmlRule->{'Range'}->__toString();
                        $separator = strpos($range, '-');
                        $rules[] = [
                            'valueLower' => intval(substr($range, 0, $separator)),
                            'valueUpper' => intval(substr($range, $separator + 1)),
                            'length' => intval($xmlRule->{'Length'}->__toString())
                        ];
                    }
                    $map[$prefix] = array_merge(array_key_exists($prefix, $map) ? $map[$prefix] : [], $rules);
                }
            return $map;
        };

        $xml = simplexml_load_file(dirname(__FILE__) . './ISBNRanges.xml');
        self::$isbnPrefixes = $loadNode($xml->{'EAN.UCCPrefixes'}, 'EAN.UCC');
        self::$isbnGroups = $loadNode($xml->{'RegistrationGroups'}, 'Group');
    }

    /**
     * @param array $map
     * @param string $prefix
     * @param int $value
     * @param int $default
     * @return int
     */
    static private function getLengthForPrefix(array $map, string $prefix, int $value, int $default): int
    {
        if (!array_key_exists($prefix, $map))
            return $default;

        $rules = $map[$prefix];
        foreach ($rules as $rule)
            if ($rule['valueLower'] <= $value && $rule['valueUpper'] >= $value)
                return $rule['length'];

        return $default;
    }

    static public function build(): string
    {
        $generateFromRule = function ($rule): string {
            $c = str_pad(random_int($rule['valueLower'], $rule['valueUpper']), 7, '0');
            if ($rule['length'] > 0)
                $c = substr($c, 0, $rule['length']);
            return $c;
        };

        $random_array = function ($a) {
            return count($a) === 0 ? null : $a[random_int(0, count($a) - 1)];
        };

        ISBN::decodeISBNRules();
        $isbn_agency = $random_array(array_keys(ISBN::$isbnPrefixes));
        do {
            // search for valid group rule
            $group_rule = $random_array(ISBN::$isbnPrefixes[$isbn_agency]);
        } while ($group_rule['length'] === 0);
        do {
            // generate valid group id
            $group = $generateFromRule($group_rule);
        } while (!array_key_exists($isbn_agency . '-' . $group, ISBN::$isbnGroups));

        do {
            // search for valid publisher rule
            $publisher_rule = $random_array(ISBN::$isbnGroups[$isbn_agency . '-' . $group]);
        } while ($publisher_rule['length'] === 0);
        $publisher = $generateFromRule($publisher_rule);

        $checksum = function ($input) {
            $sequence = (strlen($input) + 1) === 8 ? array(3, 1) : array(1, 3);
            $sums = 0;
            foreach (str_split($input) as $n => $digit) {
                $sums += $digit * $sequence[$n % 2];
            }
            return (10 - $sums % 10) % 10;
        };

        $code = $isbn_agency . $group . $publisher;

        $title_size = 12 - strlen($code);
        $title = str_pad(random_int(0, pow(10, $title_size) - 1), $title_size, '0');

        $code .= $title;
        return $code . $checksum($code);
    }
}