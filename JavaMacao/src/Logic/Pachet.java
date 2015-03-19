/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

import java.util.ArrayList;
import java.util.Collections;
import java.util.EnumSet;
import java.util.Iterator;

public class Pachet {

    private final ArrayList<Carte> pachet;

    public Pachet() {
        pachet = new ArrayList<Carte>(52);

        for (Carte.Culoare culoare : EnumSet.range(Carte.Culoare.INIMA_ROSIE, Carte.Culoare.ROMB)) {
            for (Carte.Numar numar : EnumSet.range(Carte.Numar.CINCI, Carte.Numar.AS)) {
                pachet.add(new Carte(culoare, numar));
            }
        }
    }

    public void amesteca() {
        Collections.shuffle(pachet);
    }

    public int marime() {
        return pachet.size();
    }

    public Carte imparte() {
        return imparte(1)[0];
    }

    public Carte[] imparte(int num) {
        if (num > pachet.size())
            throw new PachetPreaMicException(num, pachet.size());

        Carte[] imparte = new Carte[num];

        Iterator<Carte> iter = pachet.iterator();
        int count = 0;
        while (count < num) {
            imparte[count++] = iter.next();
            iter.remove();
        }

        return imparte;
    }

    public void reAdauga(Carte carte) {
        pachet.add(carte);
    }

    public void reAdauga(Carte[] carti) {
        for (Carte carte : carti)
            pachet.add(carte);
    }

    @Override
    public String toString() {
        return pachet.toString();
    }

}
