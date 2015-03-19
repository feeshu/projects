/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Main;
import Client.*;


public class ClientMain {
    
     public static void main(String[] args) {
        javax.swing.SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    InterfataClient frame = new InterfataClient();
                    frame.setVisible(true);
                }
            });
    }
}
