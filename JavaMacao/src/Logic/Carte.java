/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

import java.io.Serializable;

public class Carte implements Serializable {

    public enum Culoare { INIMA_ROSIE, INIMA_NEAGRA, TREFLA, ROMB, CULOARE_AS };

    public enum Numar { CINCI, SASE, SAPTE, OPT, NOUA, ZECE, VALET, REGINA, REGE, DOI, TREI, PATRU, AS };

    private final Culoare culoare;
    private final Numar numar;

    public Carte(Culoare culoare, Numar numar) {
        this.culoare = culoare;
        this.numar = numar;
    }

    public Culoare getCuloare() {
        return culoare;
    }
    
    public Numar getNumar() {
        return numar;
    }

    @Override
    public String toString() {
        return numar + " " + culoare;
    }

}

