/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Client;

public class ClientEvent {

    private enum Tip { PROTOCOL, OBIECT };
    public static final Tip PROTOCOL = Tip.PROTOCOL;
    public static final Tip OBIECT = Tip.OBIECT;

    private final Tip tip;
    private final Object continut;

    public ClientEvent(Tip tip, Object continut) {
        this.tip = tip;
        this.continut = continut;
    }

    public Tip getTip() {
        return tip;
    }

    public Object getContinut() {
        return continut;
    }

}
