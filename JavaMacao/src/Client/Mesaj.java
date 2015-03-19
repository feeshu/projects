/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Client;

public class Mesaj {

    public enum Tip { PROTOCOL, OBIECT, COMANDA }

    private final Tip tip;
    private String protocol = null;
    private Object obiect = null;
    private final String comanda = null;

    public Mesaj(String protocol) {
        tip = Tip.PROTOCOL;
        this.protocol = protocol;
    }

    public Mesaj(Object obiect) {
        tip = Tip.OBIECT;
        this.obiect = obiect;
    }

    public Mesaj(Tip tip, String comanda) {
        this.tip = tip;
        if (tip == Tip.COMANDA)
            comanda = "RESET";
        else
            comanda = "NIMIC";
    }

    public Tip getTip() {
        return tip;
    }

    public String getProtocol() {
        return protocol;
    }

    public Object getObiect() {
        return obiect;
    }

    public String getComanda() {
        return comanda;
    }

    @Override
    public String toString() {
        if (tip == Tip.PROTOCOL)
            return tip + " " + protocol;
        else if (tip == Tip.OBIECT)
            return tip + " " + obiect.toString();
        else if (tip == Tip.COMANDA)
            return tip + " " + comanda;
        else
            return "TIPUL MESAJULUI NECUNOSCUT";
            
    }

}
