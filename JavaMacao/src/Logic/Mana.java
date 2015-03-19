/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

import java.util.List;
import java.util.Arrays;
import java.util.Collection;
import java.util.LinkedList;
import java.util.Iterator;

import java.io.Serializable;

public class Mana implements Iterable<Carte>, Serializable {

    private final List<Carte> mana;

    public Mana() {
        mana = new LinkedList<Carte>();
    }

    public Mana copiaza() {
        Mana manaNoua = new Mana();
        for (Carte carte : mana)
            manaNoua.adauga(new Carte(carte.getCuloare(), carte.getNumar()));

        return manaNoua;
    }

    public void adauga(Carte carte) {
        mana.add(carte);
    }

    public void adaugaToate(Carte[] carti) {
        mana.addAll(Arrays.asList(carti));
    }

    public void adaugaToate(Collection<Carte> carti) {
        mana.addAll(carti);
    }

    public int marime() {
        return mana.size();
    }

    public boolean eGol() {
        return mana.isEmpty();
    }

    public Carte get(int index) {
        return mana.get(index);
    }

    public Carte[] getToate() {
        return mana.toArray(new Carte[0]);
    }

    public Carte sterge(int index) {
        return mana.remove(index);
    }

    public boolean sterge(Carte carte) {
        return mana.remove(carte);
    }

    @Override
    public Iterator<Carte> iterator() {
        return mana.iterator();
    }

    @Override
    public String toString() {
        return mana.toString();
    }

}