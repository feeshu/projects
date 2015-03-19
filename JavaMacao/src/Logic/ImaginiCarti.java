/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Logic;

import javax.swing.ImageIcon;

public class ImaginiCarti {

    public static final int LATIME_IMAGINE = 81;
    public static final int INALTIME_IMAGINE = 131;

    private static final ImageIcon[] TOATE = new ImageIcon[54];

    public static ImageIcon getImagine(Carte carte) {
        int index;
        
            index = carte.getNumar().ordinal() + 
                (carte.getCuloare().ordinal() * 13);

        ImageIcon cardIcon = TOATE[index];
        if (cardIcon == null) {
            cardIcon = incarcaImagine(carte);
            TOATE[index] = cardIcon;
        }

        return TOATE[index];
    }

    private static ImageIcon incarcaImagine(Carte carte) {
        String separator = "/";
        String locatie = "imagini" + separator +  
            carte.getCuloare().name() + separator + 
            carte.getNumar().name() + ".png";
        java.net.URL imageURL = ImaginiCarti.class.getResource(locatie);

            return new ImageIcon(imageURL, carte.toString());
    }

    

}