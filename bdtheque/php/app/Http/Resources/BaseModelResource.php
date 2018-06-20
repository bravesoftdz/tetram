<?php

namespace BDTheque\Http\Resources;

use BDTheque\Models\Metadata\Base;
use Illuminate\Http\Resources\Json\JsonResource;

class BaseModelResource extends JsonResource implements Base
{
    use ResourceHandlerTrait;
    protected $conditionalMerge;

    public $common_properties = [];
    public $full_properties = [];

    /**
     * BaseModelResource constructor.
     * @param mixed $resource
     * @param bool $full
     * @param BaseModelResource|null $parent
     */
    public function __construct($resource, bool $full, ?BaseModelResource $parent = null)
    {
        $this->fullResource = $full;
        $this->parentResource = $parent;
        parent::__construct($resource);
    }

    private function inheritsFrom($a, string $class): bool {
        return ($a === $class) || is_subclass_of($a, $class);
    }

    /**
     * @param $properties
     * @param $fields
     */
    protected function fill_properties($properties, &$fields)
    {
        foreach ($properties as $field => $options) {
            if (is_numeric($field)) $field = $options;

            if (!is_array($options)) {
                $fields[$field] = $this->when(isset($this->$field), $this->$field);
            } else {
                assert(count($options) >= 2);
                if ($this->inheritsFrom($options[0], BaseModelResourceCollection::class)) {
                    $fields[$field] = new $options[0]($this->whenLoaded($field), $options[1], $this);
                } else {
                    $field_id = count($options) >= 3 ? $options[2] : $field . '_id';
                    $fields[$field] = $this->when(isset($this->$field_id), function () use ($field, $options) {
                        return new $options[0]($this->$field, $options[1], $this);
                    });
                }
            }
        }
    }

    public function toArray($request)
    {
        $this->conditionalMerge = 0;

        $initiale = $this->getInitialeFieldName() !== '' ? $this->{$this->getInitialeFieldName()} : null;

        $fields = [];
        if (config('app.debug')) {
            $fields['className'] = get_class($this);
            $fields['parentClassName'] = $this->getParentResource() ? get_class($this->getParentResource()) : 'null';
            $fields['rootClassName'] = $this->getRootResource() ? get_class($this->getRootResource()) : 'null';
        }

        $fields[$this->getInitialeFieldName()] = $this->when($initiale, $initiale);
        $this->fill_properties(['id', 'notation'], $fields);

        $this->fill_properties($this->common_properties, $fields);
        if ($this->isFullResource())
            $this->fill_properties($this->full_properties, $fields);

        return $fields;
    }

}