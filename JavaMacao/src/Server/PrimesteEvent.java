/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Server;

import Client.Mesaj;

class PrimesteEvent {

    Mesaj mesaj;

    public PrimesteEvent(Mesaj mesaj) {
        this.mesaj = mesaj;
    }

    public Mesaj getMesaj() {
        return mesaj;
    }

}