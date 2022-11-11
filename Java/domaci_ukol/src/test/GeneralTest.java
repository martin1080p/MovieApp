package test;

import cz.vse.fanm02.EvidenceLyziClass;
import cz.vse.fanm02.Lyze;
import cz.vse.fanm02.Zakaznik;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Collection;
import java.util.Collections;
import java.util.LinkedList;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class GeneralTest {

    EvidenceLyziClass evidenceLyziClass;
    Lyze lyze1;
    Lyze lyze2;
    Zakaznik zakaznik;

    @BeforeEach
    void setup(){
        evidenceLyziClass = new EvidenceLyziClass();
        zakaznik = new Zakaznik("Jan", "Novák", 34);
        lyze1 = new Lyze(123, "Völkl");
        lyze2 = new Lyze(456, "Head");

        lyze1.setZakaznik(zakaznik);
        evidenceLyziClass.vlozLyze(lyze1);
        evidenceLyziClass.vlozLyze(lyze2);
    }

    @Test
    @DisplayName("Vrácení celého seznamu")
    void testList() {
        Collection<Lyze> expectedList = new LinkedList<Lyze>();
        expectedList.add(lyze1);
        expectedList.add(lyze2);

        assertEquals(expectedList, evidenceLyziClass.vratSeznam(), "Vrácení celého seznamu by mělo fungovat");
    }

    @Test
    @DisplayName("Vrácení seznamu neobsazených lyží")
    void testFreeList() {
        Collection<Lyze> expectedList = new LinkedList<Lyze>();
        expectedList.add(lyze2);

        assertEquals(expectedList, evidenceLyziClass.vratSeznamVolnychLyzi(), "Vrácení seznamu neobsazených lyží by mělo fungovat");
    }

    @Test
    @DisplayName("Vrácení lyží podle inventárního čísla")
    void testGettingSki() {
        assertEquals(lyze2, evidenceLyziClass.vratLyze(456), "Vrácení lyží podle inventárního čísla by mělo fungovat");
    }
}

