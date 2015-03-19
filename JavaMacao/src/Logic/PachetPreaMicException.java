/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

public class PachetPreaMicException extends RuntimeException {
    
    public PachetPreaMicException(int cartiCerute, int marime) {
        super("Pachetul nu are destule carti. " + cartiCerute + " carti cerute, doare " + marime + " carti disponibile");
    }

}