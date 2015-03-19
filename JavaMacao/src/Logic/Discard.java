/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

import java.util.LinkedList;

public class Discard {

    private final LinkedList<Carte> discard;

    public Discard() {
        discard = new LinkedList<Carte>();
    }

    public Carte getPrimaCarte() {
        return discard.peek();
    }

    public void adauga(Carte carte) {
        discard.push(carte);
    }

    public Carte[] eGol() {
        Carte[] carti = new Carte[discard.size()];
        discard.toArray(carti);
        return carti;
    }

}
