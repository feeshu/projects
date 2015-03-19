/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

import java.util.HashMap;

public class Oponenti extends HashMap<Integer,Oponent> {

    public boolean put(int pozitie, Oponent oponent) {
        if (containsKey((Integer) pozitie))
            return false;

        put((Integer) pozitie, oponent);
        return true;
    }

    public Oponent get(int pozitie) {
        if (! containsKey((Integer) pozitie))
            return null;

        return super.get(pozitie);
    }

}
