/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

public class Oponent implements Comparable<Oponent> {

    private String nume;
    private int pozitie;
    private int carti;

    public Oponent() {
        nume = null;
        pozitie = -1;
        carti = -1;
    }

    public Oponent(String nume, int pozitie, int carti) {
        this.nume = nume;
        this.pozitie = pozitie;
        this.carti = carti;
    }

    public boolean eCreat() {
        if (nume == null || pozitie == -1 || carti == -1)
            return false;

        return true;
    }

    public void setNume(String nume) {
        this.nume = nume;
    }

    public String getNume() {
        return nume;
    }

    public void setPozitie(int pozitie) {
        this.pozitie = pozitie;
    }

    public int getPozitie() {
        return pozitie;
    }

    public void setCarti(int carti) {
        this.carti = carti;
    }

    public int getCarti() {
        return carti;
    }

    @Override
    public int compareTo(Oponent other) {
        return this.getPozitie() - other.getPozitie();
    }

}