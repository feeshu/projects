/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Server;

import java.io.*;
import java.net.*;

import java.util.List;
import java.util.ArrayList;

import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

import java.util.Iterator;
import Logic.Joc;
import Logic.Mana;
import Client.Mesaj;
import Client.Protocol;

class ServerThread extends Thread implements ServerThreadListener {

    private enum Asteapta { NIMIC, USERNAME };

    private final List<ServerThreadListener> listeners;
    private final Queue<Mesaj> mesaje;

    boolean ruleaza;
    private boolean conectat;
    private boolean clientPregatit;
    private final Socket socket;

    private Asteapta asteapta;
    private final int pozitie;
    private String username;

    private ObjectOutputStream socketObjOut;
    private ObjectInputStream socketObjIn;

    public ServerThread(Socket socket, int pozitie) {
        super("Thread Server " + pozitie);

        listeners = new ArrayList<ServerThreadListener>();
        mesaje = new ConcurrentLinkedQueue<Mesaj>();

        this.socket = socket;
        this.pozitie = pozitie;

        socketObjOut = null;
        socketObjIn = null;

        try {
           
            socketObjOut = new ObjectOutputStream(socket.getOutputStream());
            socketObjIn = new ObjectInputStream(socket.getInputStream());

            ruleaza = true;
            conectat = true;
            System.out.println("Conectat cu " +
                               socket.getInetAddress() + 
                               " pe portul " + socket.getPort());

        } catch (IOException eStream) {
            System.err.println("Eroare la crearea fluxurilor de date.");
            try {
                socket.close();
            } catch (IOException eSocket) {
                System.out.println("Eroare la inchiderea socketului.");
            } finally {
                conectat = false;
            }
        }

        adaugaListener(this);
    }

    @Override
    public void run() {
        while (ruleaza) {
            while (! mesaje.isEmpty()) {
                Mesaj mesaj = mesaje.poll();
                if (mesaj.getTip() == Mesaj.Tip.PROTOCOL) {
                    try {
                        socketObjOut.writeObject(mesaj.getProtocol());
                        socketObjOut.flush();
                    } catch (IOException e) {
                        close();
                    }
                } else if (mesaj.getTip() == Mesaj.Tip.OBIECT) {
                    try {
                        socketObjOut.writeObject(mesaj.getObiect());
                        socketObjOut.flush();
                    } catch (IOException e) {
                        close();
                    }
                }

                System.out.println("TRIMIT:: " + 
                                   mesaj + " catre " + 
                                   socket.getInetAddress() + " de la " + 
                                   this.getName());
            }
        }

        while (! mesaje.isEmpty()) {
            Mesaj mesaj = mesaje.poll();
            if (mesaj.getTip() == Mesaj.Tip.PROTOCOL) {
                try {
                    socketObjOut.writeObject(mesaj.getProtocol());
                    socketObjOut.flush();
                } catch (IOException e) {
                    close();
                }              
            } else if (mesaj.getTip() == Mesaj.Tip.OBIECT) {
                try {
                    socketObjOut.writeObject(mesaj.getObiect());
                    socketObjOut.flush();
                } catch (IOException e) {
                    close();
                }
            }

            System.out.println("TRIMIT:: " + 
                               mesaj + " catre " + 
                               socket.getInetAddress() + " de la " + 
                               this.getName());
        }

        close();
    }

    public void close() {
        try {
            socketObjOut.close();
            socketObjIn.close();
            socket.close();
        } catch (IOException e) {
        } finally {
            conectat = false;
        }
    }

    public void setup(Joc joc) {
        Mana hand = joc.getMana(pozitie);

        clientPregatit = true;
        primeste(Protocol.Gata);

        primeste(Protocol.NumeUser);
        primesteObiect();

        trimite(Protocol.Mana);
        trimiteObiect(hand);

        trimite(Protocol.Ordine);
        trimiteObiect((Integer) pozitie);
    }

    public void trimite(String protocol) {
        mesaje.offer(new Mesaj(protocol));
    }

    public void trimiteObiect(Object obiect) {
        mesaje.offer(new Mesaj(obiect));
    }

    public void primeste(String protocol) {
        String linie = "";

        while (! linie.equals(protocol))
            linie = citesteSocketInput();

        trimiteMesajPrimit(new Mesaj(protocol));
    }

    public void primesteObiect() {
        Object obiect = citesteSocketObjInput();

        trimiteMesajPrimit(new Mesaj(obiect));
    }

    private String citesteSocketInput() {
        String linie = null;

        try {        
            linie = (String) socketObjIn.readObject();
        } catch (SocketException e) {
            System.err.println("Eroare Socket.");
            close();
        } catch (IOException e) {
            System.out.println("Eroare la citirea inputului.");
            close();
        } catch (ClassNotFoundException e) {
            System.err.println("Nu se poate gasi clasa STRING");
            conectat = false;
        }

        if (linie == null)
            close();

        return linie;
    }

    private Object citesteSocketObjInput() {
        Object obiect = null;

        try {
            obiect = socketObjIn.readObject();
        } catch (SocketException e) {
            System.err.println("Eroare la citirea obiectului din socket");
            close();
        } catch (IOException e) {
            System.err.println("Eroare la citirea socketului");
            close();
        } catch (ClassNotFoundException e) {
            System.err.println("Nu se poate gasi clasa obiectului");
        }

        return obiect;
    }

    public boolean eConectat() {
        return conectat;
    }

    public boolean ePregatit() {
        return clientPregatit;
    }

    public int getPozitie() {
        return pozitie;
    }

    public String getUsername() {
        return username;
    }

    public void adaugaListener(ServerThreadListener listener) {
        listeners.add(listener);
    }

    public void stergeListener(ServerThreadListener listener) {
        listeners.remove(listener);
    }

    private void trimiteMesajPrimit(Mesaj mesaj) {
        PrimesteEvent event = new PrimesteEvent(mesaj);
        for (Iterator<ServerThreadListener> i = new ArrayList<ServerThreadListener>(listeners).iterator(); i.hasNext();) {
            ServerThreadListener listener = i.next();
            listener.mesajPrimit(event);
        }

        System.out.println("PRIMESC:: " +
                           mesaj + " de la " + 
                           socket.getInetAddress() + " catre " +
                           this.getName());

    }

    @Override
    public void mesajPrimit(PrimesteEvent event) {
        Mesaj mesaj = event.getMesaj();
        if (mesaj.getTip() == Mesaj.Tip.PROTOCOL) {
            String protocol = mesaj.getProtocol();
            if (protocol.equals(Protocol.NumeUser))
                asteapta = Asteapta.USERNAME;
        } else if (mesaj.getTip() == Mesaj.Tip.OBIECT) {
            if (asteapta == Asteapta.USERNAME) {
                username = (String) mesaj.getObiect();
                asteapta = Asteapta.NIMIC;
            }
        }
    }
}
