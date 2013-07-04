package org.tetram.bdtheque.test.utils;

import junit.framework.TestCase;

import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

public class StringUtilsTest extends TestCase {

    private static final String STRING_UUID = "755649d4-7c6d-4b31-ab7e-92fdfee6a4af";
    private static final String STRING_GUID = "{755649D4-7C6D-4B31-AB7E-92FDFEE6A4AF}";
    private final UUID uuidRef = UUID.fromString(STRING_UUID);

    @Override
    public void setUp() throws Exception {
        super.setUp();
    }

    @Override
    public void tearDown() throws Exception {
        super.tearDown();
    }

    public void testGUIDStringToUUID() throws Exception {
        UUID testUUID = org.tetram.bdtheque.utils.StringUtils.GUIDStringToUUID(STRING_GUID);
        assertEquals("GUIDStringToUUID", this.uuidRef, testUUID);
    }

    public void testGUIDStringToUUIDDef() throws Exception {
        UUID testUUID;
        testUUID = org.tetram.bdtheque.utils.StringUtils.GUIDStringToUUIDDef(STRING_GUID, org.tetram.bdtheque.utils.StringUtils.GUID_FULL);
        assertEquals("GUIDStringToUUIDDef: default not used", this.uuidRef, testUUID);

        testUUID = org.tetram.bdtheque.utils.StringUtils.GUIDStringToUUIDDef("xxx", org.tetram.bdtheque.utils.StringUtils.GUID_FULL);
        assertEquals("GUIDStringToUUIDDef: default returned", org.tetram.bdtheque.utils.StringUtils.GUID_FULL, testUUID);
    }

    public void testUUIDToGUIDString() throws Exception {
        assertEquals("UUIDToGUIDString", STRING_GUID, StringUtils.UUIDToGUIDString(this.uuidRef));
    }

    public void testAjoutString() throws Exception {
        assertEquals("ajout", StringUtils.ajoutString("", "ajout", "espace"));
        assertEquals("chaineespaceajout", StringUtils.ajoutString("chaine", "ajout", "espace"));
        assertEquals("chaine", StringUtils.ajoutString("chaine", "", "espace"));
        assertEquals("chaineespaceavantajoutapres", StringUtils.ajoutString("chaine", "ajout", "espace", "avant", "apres"));
        assertEquals("chaine", StringUtils.ajoutString("chaine", "", "espace", "avant", "apres"));
    }

    public void testNonZero() throws Exception {
        assertEquals("NonZero (Integer,null)", "", StringUtils.nonZero((Integer) null));
        assertEquals("NonZero (Integer,0)", "", StringUtils.nonZero(0));
        assertEquals("NonZero (Integer,1)", "1", StringUtils.nonZero(1));
        assertEquals("NonZero (String,null)", "", StringUtils.nonZero((String) null));
        assertEquals("NonZero (String,0)", "", StringUtils.nonZero("0"));
        assertEquals("NonZero (String,1)", "1", StringUtils.nonZero("1"));
    }

    public void testFormatISBN() throws Exception {
        assertEquals("978-0-7777-7777-0", StringUtils.formatISBN("9780777777770"));
        assertEquals("978-952-89-8888-5", StringUtils.formatISBN("9789528988885"));
        assertEquals("978-2-921548-21-2", StringUtils.formatISBN("9782921548212"));
        assertEquals("2-921548-21-6", StringUtils.formatISBN("2921548216"));
    }

    public void testClearISBN() throws Exception {

    }

    public void testFormatTitre() throws Exception {
        assertEquals("test", StringUtils.formatTitre("test"));
        assertEquals("un test", StringUtils.formatTitre("test[un]"));
        assertEquals("un test", StringUtils.formatTitre("test[un] "));
        assertEquals("un test", StringUtils.formatTitre("test [un]"));
        assertEquals("un test", StringUtils.formatTitre("test [ un]"));
        assertEquals("un test", StringUtils.formatTitre("test [un ]"));
        assertEquals("un test", StringUtils.formatTitre("test [un ] "));
        assertEquals("un test de plus", StringUtils.formatTitre("test [un]de plus"));
        assertEquals("un test  de plus", StringUtils.formatTitre("test [ un ] de plus"));
        assertEquals("un test de plus", StringUtils.formatTitre("test[un] de plus"));
        assertEquals("un testde plus", StringUtils.formatTitre("test[un]de plus"));

        assertEquals("l'test", StringUtils.formatTitre("test[l']"));
        assertEquals("l'test", StringUtils.formatTitre("test[l'] "));
        assertEquals("l'test", StringUtils.formatTitre("test [l']"));
        assertEquals("l'test", StringUtils.formatTitre("test [ l']"));
        assertEquals("l'test", StringUtils.formatTitre("test [l' ]"));
        assertEquals("l'test", StringUtils.formatTitre("test [l' ] "));
        assertEquals("l'test de plus", StringUtils.formatTitre("test [l']de plus"));
        assertEquals("l'test  de plus", StringUtils.formatTitre("test [ l' ] de plus"));
        assertEquals("l'test de plus", StringUtils.formatTitre("test[l'] de plus"));
        assertEquals("l'testde plus", StringUtils.formatTitre("test[l']de plus"));

        assertEquals("Trolls de Troy", StringUtils.formatTitre("Trolls de Troy"));
        assertEquals("Le Scorpion", StringUtils.formatTitre("Scorpion [Le]"));
        assertEquals("L'Etape", StringUtils.formatTitre("Etape [L']"));
    }

    public void testTrimRight() throws Exception {
        assertEquals("xxxx", StringUtils.trimRight("xxxx"));
        assertEquals("xxxx", StringUtils.trimRight("xxxx   "));
        assertEquals("   xxxx", StringUtils.trimRight("   xxxx   "));
        assertEquals("   xxxx", StringUtils.trimRight("   xxxx"));
    }

    public void testFormatTitreAlbum() throws Exception {

    }
}
