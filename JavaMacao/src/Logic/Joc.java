/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

public class Joc {

    private static final int NUMAR_MAINI = 2;
    private static final int NUMAR_CARTI = 5;

    private boolean seJoaca;
    private Pachet pachet;
    private Discard discard;
    private Mana[] maini;
    private int jucatori;
    private int randCurent;
    private int directie;
    private Carte.Culoare culoareAs;

    public Joc() {
        this(NUMAR_MAINI, NUMAR_CARTI);
    }

    public Joc(int jucatori) {
        this(jucatori, NUMAR_CARTI);
    }      

    public Joc(int jucatori, int carti) {
        pachet = new Pachet();
        pachet.amesteca();

        this.jucatori = jucatori;
        maini = new Mana[jucatori];
        for (int i = 0; i < jucatori; ++i) {
            Mana mana = new Mana();
            mana.adaugaToate(pachet.imparte(carti));
            maini[i] = mana;
        }

        discard = new Discard();
        Carte carteDiscard = pachet.imparte();
        Carte.Numar numarDiscard = carteDiscard.getNumar();
        while (numarDiscard.ordinal() > Carte.Numar.REGE.ordinal()) {
            pachet.reAdauga(carteDiscard);
            pachet.amesteca();
            carteDiscard = pachet.imparte();
            numarDiscard = carteDiscard.getNumar();
        }
        discard.adauga(carteDiscard);

        randCurent = 0;
        directie = 1;
        seJoaca = false;
    }

    public void start() {
        seJoaca = true;
    }

    public void stop() {
        seJoaca = false;
    }

    public boolean seJoaca() {
        return seJoaca;
    }

    public void next() {  
        if (! sePoateJuca()) {
            if (jucatori == 2)
                randCurent += directie;
            directie *= -1;
        } else if (discard.getPrimaCarte().getNumar() == Carte.Numar.PATRU)
            randCurent += directie;

        randCurent += directie;
        
        if (randCurent >= jucatori)
            while (randCurent >= jucatori)
                randCurent -= jucatori;
        else if (randCurent < 0)
            while (randCurent < 0)
                randCurent += jucatori;
    }
    
    public Mana getManaCurenta() {
        return maini[randCurent];
    }

    public Mana getMana(int index) {
        return maini[index];
    }

    public int getNumarJucatorCurent() {
        return randCurent;
    }

    public int getDirectie() {
        return directie;
    }

    public int getJucatori() {
        return jucatori;
    }

    public Carte primaCarteDiscard() {
        return discard.getPrimaCarte();
    }

    public boolean sePoateJuca() {
        Mana mana = getManaCurenta();
        Carte discard = primaCarteDiscard();

        for (Carte carte : mana)
            if (carte.getCuloare() == discard.getCuloare() ||
                carte.getNumar() == discard.getNumar() ||
                carte.getCuloare() == Carte.Culoare.CULOARE_AS ||
                (discard.getCuloare() == Carte.Culoare.CULOARE_AS && carte.getCuloare() == culoareAs))
                return true;
        
        return false;

    }

    public boolean joacaCartea(int index) {
        Mana mana = getManaCurenta();
        Carte carte = mana.get(index);

        if (carte != null &&            
            (( primaCarteDiscard().getCuloare() == Carte.Culoare.CULOARE_AS && carte.getCuloare() == culoareAs) ||
             carte.getCuloare() == primaCarteDiscard().getCuloare() ||
             carte.getNumar() == primaCarteDiscard().getNumar())) {

            discard.adauga(mana.sterge(index));
            return true;
        }

        return false;
    }

    public Carte trageCarte() {
        if (pachet.marime() == 0) {
            pachet.reAdauga(discard.eGol());
            pachet.amesteca();
        }

        Mana mana = getManaCurenta();
        Carte carte = pachet.imparte();
        mana.adauga(carte);

        return carte;
    }
    
    public void setSchimbaCuloare(Carte.Culoare culoare) {
        if (primaCarteDiscard().getCuloare() != Carte.Culoare.CULOARE_AS)
            return;
        
        culoareAs = culoare;
    }
    
    public Carte.Culoare getSchimbaCuloare() {
        return culoareAs;
    }
}
