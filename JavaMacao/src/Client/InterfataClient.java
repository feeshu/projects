/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Client;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.event.*;
import Logic.Carte;
import Logic.ImaginiCarti;
import Logic.Joc;
import Logic.Mana;
import Logic.Oponent;
import Logic.Oponenti;

public class InterfataClient extends JFrame {

    private final JFrame frame;

    private final Action actiuneConectare;
    private final Action actiuneDeconectare;
    private final Action actiuneIesire;
    private final Action actiuneJoc;

    private final PanouCarti panouMana;
    private final PanouDiscard panouDiscard;
    private final JLabel etichetaStatus;

    private final ClientEventHandler clientEventHandler;

    private Client client;
    private String host;
    private int port;

    private String username;
    private int ordineJoc;
    private final Oponenti oponenti;
    private Mana mana;
    private Carte discard;
    private Carte.Culoare culoareAs;
    private Carte carteJucata;

    private volatile boolean rand;
    private volatile boolean incepe;
    private volatile boolean seJoaca;
    private volatile boolean intraJucator;
    private volatile boolean trageCarte;

    public InterfataClient() {
        super("Macao - Marin Alexandru GR. 253");

        rand = false;
        incepe = false;
        seJoaca = false;
        intraJucator = false;
        trageCarte = false;

        frame = this;
        oponenti = new Oponenti();

        actiuneConectare = new ActiuneConectare();
        actiuneDeconectare = new ActiuneDeconectare();
        actiuneIesire = new ActiuneIesire();

        actiuneJoc = new ActiuneJoc();
        actiuneJoc.setEnabled(false);

        clientEventHandler = new ClientEventHandler();

        JMenuItem itemMeniuConectare = new JMenuItem(actiuneConectare);
        JMenuItem itemMeniuDeconectare = new JMenuItem(actiuneDeconectare);
        JMenuItem itemMeniuIesire = new JMenuItem(actiuneIesire);

        JMenu meniu = new JMenu("Meniu");
        meniu.add(itemMeniuConectare);
        meniu.add(itemMeniuDeconectare);
        meniu.addSeparator();
        meniu.add(itemMeniuIesire);

        JMenuBar baraMeniu = new JMenuBar();
        baraMeniu.add(meniu);
        setJMenuBar(baraMeniu);

        Color bgColor = new Color(68, 137, 56);

        panouMana = new PanouCarti();
        panouMana.setBackground(bgColor);
        Mana mana = new Joc().getManaCurenta();
        panouMana.setCarti(mana.getToate());

        JButton playButton = new JButton(actiuneJoc);

        panouDiscard = new PanouDiscard();
        panouDiscard.setBackground(bgColor);
        
        JPanel panouMasa = new JPanel();
        panouMasa.setBackground(bgColor);
        panouMasa.add(panouMana);
        panouMasa.add(playButton);
        panouMasa.add(panouDiscard);

        etichetaStatus = new JLabel("Conectati-va");

        Container panou = getContentPane();

        panou.add(panouMasa, BorderLayout.CENTER);
        panou.add(etichetaStatus, BorderLayout.SOUTH);

        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(700, 400);
        setLocationRelativeTo(null);
    }

    private void connect() {
        client = new Client(host, port);
        client.adaugaClientEventListener(clientEventHandler);

        if (! client.connect()) {
            etichetaStatus.setText("Nu se poate conecta");
            JOptionPane.showMessageDialog(frame, 
                                          "Nu se poate conecta la " + host,
                                          "Eroare conexiune",
                                          JOptionPane.ERROR_MESSAGE);
        } else {
            etichetaStatus.setText("Conectat");
            new Thread() {
                @Override
                public void run() {
                    setup();
                }
            }.start();
        }
    }
    
    private void setup() {
        client.trimite(Protocol.Gata);

        client.trimite(Protocol.NumeUser);
        client.trimite(username);

        client.primeste(Protocol.Mana);
        client.primesteObiect();

        client.primeste(Protocol.Ordine);
        client.primesteObiect();

        client.primeste(Protocol.Start);
    }

    private void startGame() {
        while (incepe) {
            primesteUser();
        }

        client.primesteSeJoaca();
    }

    private void sfarsitJoc() {
        client.primesteCastigator();
    }

    private void castigator() {
        System.out.println("Ai castigat!");
    }

    private void pierzator() {
        System.out.println("Ai pierdut");
    }

    private void primesteUser() {
        client.primesteUser();
        if (incepe) {
            client.primeste(Protocol.NumeUser);
            client.primesteObiect();
            
            client.primeste(Protocol.Ordine);
            client.primesteObiect();
            
            client.primeste(Protocol.NumarCarti);
            client.primesteObiect();

            client.primeste(Protocol.SfarsitUser);
        }
    }

    private void primesteJucator() {
        client.primesteJucator();
    }

    private void joacaRunda() {
        client.primesteRand();

        client.primesteJucator();
        while (intraJucator) {
            client.primeste(Protocol.Ordine);
            client.primesteObiect();

            client.primeste(Protocol.NumarCarti);
            client.primesteObiect();

            client.primesteJucator();
        }

        if (rand) {
            client.primesteTrage();
            while (trageCarte) {
                client.primesteObiect();
                client.primesteTrage();
            }

            client.primeste(Protocol.Mana);
            client.primesteObiect();

            client.primeste(Protocol.Discard);
            client.primesteObiect();  
            
            if(esteAsDiscard()) {
                client.primeste(Protocol.GetCuloareAs);
                client.primesteObiect();
            }

            client.primeste(Protocol.CereCarte);
            actiuneJoc.setEnabled(true);
        } else {
            client.primeste(Protocol.Discard);
            client.primesteObiect();

            client.primesteSeJoaca();
        }
    }

    private void joacaCartea(int carte) {
        if (sePoateJucaCartea(carte)) {
            client.trimite(Protocol.JoacaCartea);
            client.trimiteObiect((Integer) carte);
          //  panouMana.stergeCarte(carte);
            actiuneJoc.setEnabled(false);
            
            if (esteAs(carte)) {
                panouDiscard.adaugaButoaneCulori();
                Carte.Culoare culoare = panouDiscard.getAlegereCuloareAs();
                client.trimite(Protocol.SetCuloareAs);
                client.trimiteObiect(culoare);
                client.primeste(Protocol.Succes);
                panouDiscard.reseteazaAlegereCuloareAs();
            }

            client.primeste(Protocol.Succes);
            client.primesteSeJoaca();
        } else {
            System.out.println("nu se poate juca cartea: " 
                               + carte + "  " + mana.get(carte));
        }
        repaint();
    }

    private void setIncepe(boolean incepe) {
        this.incepe = incepe;
    }

    private void setSeJoaca(boolean seJoaca) {
        this.seJoaca = seJoaca;
    }

    private void setSfarsit(boolean sfarsit) {
        this.seJoaca = ! sfarsit;
        sfarsitJoc();
    }

    private void setRand(boolean rand) {
        this.rand = rand;
    }

    private void setIntraJucator(boolean intraJucator) {
        this.intraJucator = intraJucator;
    }

    private void setMana(final Mana mana) {
        this.mana = mana;
        SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    panouMana.setCarti(mana.getToate());
                    repaint();
                }
            });
    }

    private void adaugaCarte(final Carte carte) {
       
        SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    panouMana.adaugaCarte(carte);
                    repaint();
                }
            }); 
        
    }

    private void setDiscard(Carte carte) {
        discard = carte;
        panouDiscard.setDiscard(carte);
        repaint();
    }
    
    private void setCuloareAs(Carte.Culoare culoare) {
        culoareAs = culoare;
        panouDiscard.setAs(culoare);
        repaint();
    }
    
    private boolean esteAsDiscard() {
        return discard.getNumar() == Carte.Numar.AS;
    }
    
    private boolean esteAsJucat() {
        return carteJucata.getNumar() == Carte.Numar.AS;
    }

    private boolean sePoateJucaCartea(int cardIndex) {
        Carte carte = mana.get(cardIndex);

        if (carte != null &&
            (carte.getNumar() == Carte.Numar.AS ||
             carte.getCuloare() == discard.getCuloare() ||
             carte.getNumar() == discard.getNumar())) {

            return true;
        }

        return false;
    }
    
    private boolean esteAs(int index) {
        return mana.get(index).getNumar() == Carte.Numar.AS;
    }

    private class ActiuneConectare extends AbstractAction {
        private DialogConectare dialogConectare;

        public ActiuneConectare() {
            super("Conectare");

            dialogConectare = new DialogConectare();
            dialogConectare.butonAcceptare.addActionListener(new ActionListener() {
                    @Override
                    public void actionPerformed(ActionEvent event) {
                        host = dialogConectare.getServer();
                        username = dialogConectare.getUsername();
                        port = dialogConectare.getPort();

                        etichetaStatus.setText("Se conecteaza...");
                        connect();
                    }
                });
        }

        @Override
        public void actionPerformed(ActionEvent event) {
            dialogConectare.setVisible(true);
        }

        private class DialogConectare extends JDialog {

            private final JTextField campTextServer;
            private final JTextField campTextUsername;
            private final SpinnerNumberModel modelPort;
            private final JSpinner derularePort;
            private JButton butonAcceptare;

            public DialogConectare() {
                super(frame, "Conectare", true);
                
                TextFieldDocumentHandler documentHandler = 
                    new TextFieldDocumentHandler();

                campTextServer = new JTextField(10);
                campTextServer.getDocument()
                    .addDocumentListener(documentHandler);

                campTextUsername = new JTextField(10);
                campTextUsername.getDocument()
                    .addDocumentListener(documentHandler);

                modelPort = new SpinnerNumberModel(Protocol.PORT,
                                                   1024, 65535, 1);
                derularePort = new JSpinner(modelPort);
                derularePort.setEditor(new JSpinner.NumberEditor(derularePort, 
                                                                "#"));
                ((JSpinner.DefaultEditor) derularePort.getEditor())
                    .getTextField().setHorizontalAlignment(JTextField.LEFT);

                JLabel etichetaServer = new JLabel("Server");
                etichetaServer.setLabelFor(campTextServer);

                JLabel etichetaNumeUser = new JLabel("NumeUser");
                etichetaNumeUser.setLabelFor(campTextUsername);

                JLabel etichetaPort = new JLabel("Port");
                etichetaPort.setLabelFor(derularePort);

                butonAcceptare = new JButton("Conectare");
                butonAcceptare.setEnabled(false);
                butonAcceptare.addActionListener(new ActionListener() {
                        @Override
                        public void actionPerformed(ActionEvent event) {
                            if (!getServer().equals(""))
                                setVisible(false);
                        }
                    });

                JButton butonAnulare = new JButton("Anulare");
                butonAnulare.addActionListener(new ActionListener() {
                        @Override
                        public void actionPerformed(ActionEvent event) {
                            setVisible(false);
                        }
                    });

                Container continut = getContentPane();

                GroupLayout layout = new GroupLayout(continut);
                layout.setAutoCreateGaps(true);
                layout.setAutoCreateContainerGaps(true);
                continut.setLayout(layout);

                layout.setHorizontalGroup(
                                          layout.createSequentialGroup()
                                          .addGroup(layout.createParallelGroup(GroupLayout.Alignment.TRAILING)
                                                    .addComponent(etichetaServer)
                                                    .addComponent(etichetaNumeUser)
                                                    .addComponent(etichetaPort))
                                          .addGroup(layout.createParallelGroup(GroupLayout.Alignment.LEADING)
                                                    .addComponent(campTextServer)
                                                    .addComponent(campTextUsername)
                                                    .addComponent(derularePort)
                                                    .addGroup(layout.createSequentialGroup()
                                                              .addPreferredGap(LayoutStyle.ComponentPlacement.RELATED, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                                              .addComponent(butonAcceptare)
                                                              .addComponent(butonAnulare))));

                layout.setVerticalGroup(
                                        layout.createSequentialGroup()
                                        .addGroup(layout.createParallelGroup(GroupLayout.Alignment.BASELINE)
                                                  .addComponent(etichetaServer)
                                                  .addComponent(campTextServer))
                                        .addGroup(layout.createParallelGroup(GroupLayout.Alignment.BASELINE)
                                                  .addComponent(etichetaNumeUser)
                                                  .addComponent(campTextUsername))
                                        .addGroup(layout.createParallelGroup(GroupLayout.Alignment.BASELINE)
                                                  .addComponent(etichetaPort)
                                                  .addComponent(derularePort))
                                        .addGroup(layout.createParallelGroup(GroupLayout.Alignment.BASELINE)
                                                  .addComponent(butonAcceptare)
                                                  .addComponent(butonAnulare)));

                addWindowListener(new WindowHandler());

                pack();
                setResizable(false);
                setLocationRelativeTo(frame);
            }

            public String getServer() {
                return campTextServer.getText();
            }

            public String getUsername() {
                return campTextUsername.getText();
            }

            public int getPort() {
                return ((Integer) modelPort.getNumber()).intValue();
            }

            private class TextFieldDocumentHandler implements DocumentListener {
                private boolean serverSetat;
                private boolean usernameSetat;

                @Override
                public void insertUpdate(DocumentEvent documentEvent) {
                    if (! getServer().equals(""))
                        serverSetat = true;
                    else
                        serverSetat = false;

                    if (! getUsername().equals(""))
                        usernameSetat = true;
                    else
                        usernameSetat = false;

                    if (serverSetat && usernameSetat)
                        butonAcceptare.setEnabled(true);
                    else
                        butonAcceptare.setEnabled(false);
                }

                @Override
                public void removeUpdate(DocumentEvent documentEvent) {
                    if (! getServer().equals(""))
                        serverSetat = true;
                    else
                        serverSetat = false;

                    if (! getUsername().equals(""))
                        usernameSetat = true;
                    else
                        usernameSetat = false;

                    if (serverSetat && usernameSetat)
                        butonAcceptare.setEnabled(true);
                    else
                        butonAcceptare.setEnabled(false);
                }

                @Override
                public void changedUpdate(DocumentEvent documentEvent) {
                }
            }
            
            private class WindowHandler extends WindowAdapter {
                @Override
                public void windowClosing(WindowEvent windowEvent) {
                    setVisible(false);
                }
            }
        }
    }

    private class ActiuneDeconectare extends AbstractAction {
        public ActiuneDeconectare() {
            super("Deconectare");
        }

        @Override
        public void actionPerformed(ActionEvent event) {
            System.out.println("deconectare");
        }
    }

    private class ActiuneIesire extends AbstractAction {
        public ActiuneIesire() {
            super("Iesire");
        }

        @Override
        public void actionPerformed(ActionEvent event) {
            dispose();
        }
    }

    private class ActiuneJoc extends AbstractAction {
        public ActiuneJoc() {
            super("Joaca");
        }

        @Override
        public void actionPerformed(ActionEvent event) {
            final int carte = panouMana.getSelected();
            new Thread() {
                @Override
                public void run() {
                    joacaCartea(carte);
                }
            }.start();
        }
    }

    private class PanouCarti extends JPanel {
        
        private int index;

        private static final int SUPRAPUNERE = 0;

        private final JLayeredPane panouStraturi;
        private final ButtonGroup grupButoane;

        public PanouCarti() {
            super();
            
            panouStraturi = new JLayeredPane();
            

            grupButoane = new ButtonGroup();
            add(panouStraturi);
        }

        public void setCarti(Carte[] carti) {
            int i;
            panouStraturi.removeAll();
            for (i = 0; i < carti.length; ++i) {
                Carte carte = carti[i];
                ButonCarte butonCarte = 
                    new ButonCarte(ImaginiCarti.getImagine(carte));
                butonCarte.setActionCommand(i + "");
                butonCarte.setBounds(i * ImaginiCarti.LATIME_IMAGINE - i * SUPRAPUNERE,
                                     0,
                                     ImaginiCarti.LATIME_IMAGINE,
                                     ImaginiCarti.INALTIME_IMAGINE + 10);
                
                grupButoane.add(butonCarte);
                panouStraturi.add(butonCarte, new Integer(i));
                index = i+1;
            }

            panouStraturi
                .setPreferredSize(new Dimension(ImaginiCarti.LATIME_IMAGINE * i,
                                                ImaginiCarti.INALTIME_IMAGINE + 10));

            panouStraturi.revalidate();
            System.out.println("carti setate");
        }
        
        public void adaugaCarte(Carte carte) {
            ButonCarte butonCarte = new ButonCarte(ImaginiCarti.getImagine(carte));
            butonCarte.setActionCommand(index++ + "");
            grupButoane.add(butonCarte);
            add(butonCarte);
            
            revalidate();
        }      
        

        public void stergeCarte(int carte) {
           // remove(carte);
            revalidate();
        }

        public int getSelected() {
            return Integer.parseInt(grupButoane
                                    .getSelection().getActionCommand());
        }

        private class ButonCarte extends JToggleButton {
            private final Image imagine;
            private final Dimension marime;

            public ButonCarte(ImageIcon icon) {
                super();
                setIcon(icon);
                imagine = icon.getImage();
                marime = new Dimension(icon.getIconWidth(), 
                                     icon.getIconHeight() + 10);
                setOpaque(false);
            }

            @Override
            protected void paintComponent(Graphics g) {
                if (isSelected())
                    g.drawImage(imagine, 0, 0, this);
                else
                    g.drawImage(imagine, 0, 10, this);
            }

            @Override
            protected void paintBorder(Graphics g) { }
        }
    }

    private class PanouDiscard extends JPanel {
        private final JLabel etichetaDiscard;
        private JLabel etichetaAs;
        
        private JButton butonInimaRosie;
        private JButton butonInimaNeagra;
        private JButton butonTrefla;
        private JButton butonRomb;
        
        private volatile Carte.Culoare discardAs;


        public PanouDiscard() {
            etichetaDiscard = new JLabel("");
            add(etichetaDiscard);
            
            etichetaAs = new JLabel("");
            etichetaAs.setEnabled(false);
            
            HandlerButonAs handlerButonAs = new HandlerButonAs();
            
            butonInimaRosie = new JButton("Inima Rosie");
            butonInimaRosie.setActionCommand("inima rosie");
            butonInimaRosie.addActionListener(handlerButonAs);
            
            butonInimaNeagra = new JButton("Inima Neagra");
            butonInimaNeagra.setActionCommand("inima neagra");
            butonInimaNeagra.addActionListener(handlerButonAs);
            
            butonTrefla = new JButton("Trefla");
            butonTrefla.setActionCommand("trefla");
            butonTrefla.addActionListener(handlerButonAs);
            
            butonRomb = new JButton("Romb");
            butonRomb.setActionCommand("romb");
            butonRomb.addActionListener(handlerButonAs);           

        }

        public void setDiscard(Carte carte) {
            stergeAs();
            etichetaDiscard.setIcon(ImaginiCarti.getImagine(carte));
            revalidate();
        }
        
        public void setAs(Carte.Culoare culoare) {
            etichetaAs.setText(culoare.toString());
            etichetaAs.setEnabled(true);
            add(etichetaAs);
            revalidate();
        }
        
        public void stergeAs() {
            if (etichetaAs.isEnabled()) {
                remove(etichetaAs);
                etichetaAs.setEnabled(false);
                revalidate();
            }
        }
        
        public void adaugaButoaneCulori() {
            add(butonInimaRosie);
            add(butonInimaNeagra);
            add(butonTrefla);
            add(butonRomb);
            revalidate();
        }
        
        public void stergeButoaneCulori() {
            remove(butonInimaRosie);
            remove(butonInimaNeagra);
            remove(butonTrefla);
            remove(butonRomb);
            revalidate();
        }
        
        public Carte.Culoare getAlegereCuloareAs() {
            while(discardAs == discard.getCuloare()) {}
            return discardAs;
        }
        
        public void reseteazaAlegereCuloareAs() {
            discardAs = discard.getCuloare();
        }
        
        private class HandlerButonAs implements ActionListener {
            public void actionPerformed(ActionEvent event) {
                String culoare = event.getActionCommand();
                
                if(culoare.equals("inima rosie"))
                    discardAs = Carte.Culoare.INIMA_ROSIE;
                if(culoare.equals("inima neagra"))
                    discardAs = Carte.Culoare.INIMA_NEAGRA;
                if(culoare.equals("trefla"))
                    discardAs = Carte.Culoare.TREFLA;
                if(culoare.equals("romb"))
                    discardAs = Carte.Culoare.ROMB;
                
                stergeButoaneCulori();
            }
        }
    }

    private class ClientEventHandler implements ClientEventListener {
        private String asteapta;
        
        private boolean userIntrat;
        private Oponent oponentCurent;
        private int pozitieOponent;
        private int numarCartiOponent;

        @Override
        public void primesteActiuneCompleta(ClientEvent event) {
            //System.out.println(event.getContinut());
            String continut = (String) event.getContinut();
            asteapta = continut;
            if (incepe) {
                if (continut.equals(Protocol.User)) {
                    userIntrat = true;
                    oponentCurent = new Oponent();
                } else if (continut.equals(Protocol.SfarsitUser)) {
                    userIntrat = false;
                    if (oponentCurent.eCreat())
                        oponenti.put(oponentCurent.getPozitie(), 
                                      oponentCurent);
                    else
                        System.out.println("user incomplet");
                } else if (continut.equals(Protocol.NiciunUser))
                    setIncepe(false);
            } else {
                if (continut.equals(Protocol.Start)) {
                    setIncepe(true);
                    new Thread() {
                        @Override
                        public void run() {
                            startGame();
                        }
                    }.start();
                } else if (continut.equals(Protocol.Joaca)) {
                    setSeJoaca(true);
                    new Thread() {
                        @Override
                        public void run() {
                            joacaRunda();
                        }
                    }.start();
                } else if (continut.equals(Protocol.Sfarsit))
                    setSfarsit(true);
                else if (continut.equals(Protocol.Castigator))
                    castigator();
                else if (continut.equals(Protocol.Pierzator))
                    pierzator();
                else if (continut.equals(Protocol.Rand))
                    setRand(true);
                else if (continut.equals(Protocol.RandulCeluilalt))
                    setRand(false);
                else if (continut.equals(Protocol.Jucator)) {
                    userIntrat = true;
                    setIntraJucator(true);
                } else if (continut.equals(Protocol.SfarsitJucator)) {
                    userIntrat = false;
                    oponentCurent = oponenti.get(pozitieOponent);
                    oponentCurent.setCarti(numarCartiOponent);
                } else if (continut.equals(Protocol.NiciunJucator))
                    setIntraJucator(false);
                else if (continut.equals(Protocol.Trage))
                    trageCarte = true;
                else if (continut.equals(Protocol.NuTrage))
                    trageCarte = false;
            }
        }
        
        @Override
        public void primesteObiectComplet(ClientEvent event) {
            if (incepe) {
                if (userIntrat) {
                    if (asteapta.equals(Protocol.NumeUser))
                        oponentCurent.setNume((String) event.getContinut());
                    else if (asteapta.equals(Protocol.Ordine))
                        oponentCurent
                            .setPozitie(((Integer) event.getContinut()).intValue());
                    else if (asteapta.equals(Protocol.NumarCarti))
                        oponentCurent
                            .setCarti(((Integer) event.getContinut()).intValue());
                }
            } else if (seJoaca) {
                if (asteapta.equals(Protocol.Mana)) {
                    final Mana mana = (Mana) event.getContinut();
                    SwingUtilities.invokeLater(new Runnable() {
                            @Override
                            public void run() {
                                setMana(mana);
                            }
                        });
                } else if (asteapta.equals(Protocol.Discard))
                    setDiscard((Carte) event.getContinut());  
                else if (asteapta.equals(Protocol.GetCuloareAs))
                    setCuloareAs((Carte.Culoare) event.getContinut());
                if (userIntrat) {
                    if (asteapta.equals(Protocol.Ordine))
                        pozitieOponent = ((Integer) event.getContinut())
                            .intValue();
                    else if (asteapta.equals(Protocol.NumarCarti))
                        numarCartiOponent = ((Integer) event.getContinut())
                            .intValue();
                } else if (rand) {
                    if (asteapta.equals(Protocol.Trage))
                        adaugaCarte((Carte) event.getContinut());
                }
            } else {
                if (asteapta.equals(Protocol.Mana)) {
                    final Mana mana = (Mana) event.getContinut();
                    SwingUtilities.invokeLater(new Runnable() {
                            @Override
                            public void run() {
                                setMana(mana);
                            }
                        });
                }
                else if (asteapta.equals(Protocol.Ordine))
                    ordineJoc = ((Integer) event.getContinut()).intValue();
            }
        }
    }

}
