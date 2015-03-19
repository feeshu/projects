/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Server;

import java.io.*;
import java.net.*;

import java.util.ArrayList;
import java.util.Iterator;

import Logic.Carte;
import Logic.Joc;
import Client.Mesaj;
import Client.Protocol;

public class Server implements ServerThreadListener {

    private enum Asteapta { NIMIC, CARTE, AS };

    private ServerSocket listener;
    private ArrayList<ServerThread> clienti;
    private int jucatori;
    private Joc joc;
    private boolean clientiPregatiti;
    private boolean jucatorATerminat;
    private int castigator;
    private Asteapta asteapta;

    public Server() {
        this(Protocol.PORT, 4);
    }

    public Server(int jucatori) {
        this(Protocol.PORT, jucatori);
    }

    public Server(int port, int jucatori) {
        this.jucatori = jucatori;

        clienti = new ArrayList<ServerThread>(jucatori);
        clientiPregatiti = false;

        try {
            listener = new ServerSocket(port);
        } catch (IOException e) {
            System.err.println("Nu se poate crea server pe portul " + port);
            System.exit(-1);
        }

        joc = new Joc(jucatori);
    }

    public void asculta() {
        while(clienti.size() < jucatori) {
            try {
                Socket conexiune = listener.accept();
                final ServerThread client = new ServerThread(conexiune, clienti.size());
                client.adaugaListener(this);
                client.start();
                new Thread() {
                    @Override
                    public void run() {
                        client.setup(joc);
                    }
                }.start();
                clienti.add(client);
            } catch (IOException e) {
                System.err.println("Eroare de conexiune");
            }

            verificaConexiuni();
        }
    }

    public void start() {
        try {
            listener.close();
        } catch (IOException e) {
            System.err.println("Eroare la oprirea listenerului.");
        }

        joc.start();

        for (ServerThread client : clienti) {
            client.trimite(Protocol.Start);

            for (ServerThread celalaltClient : clienti) {
                if (client != celalaltClient) {
                    client.trimite(Protocol.User);

                    client.trimite(Protocol.NumeUser);
                    client.trimiteObiect(celalaltClient.getUsername());

                    client.trimite(Protocol.Ordine);
                    client.trimiteObiect(celalaltClient.getPozitie());

                    client.trimite(Protocol.NumarCarti);
                    client.trimiteObiect(joc.getMana(celalaltClient.getPozitie()).marime());

                    client.trimite(Protocol.SfarsitUser);
                }
            }
            client.trimite(Protocol.NiciunUser);
        }
    }

    public void jocIncheiat() {
        joc.stop();

        for (ServerThread client : clienti) {
            client.trimite(Protocol.Sfarsit);

            if (client.getPozitie() == getCastigator())
                client.trimite(Protocol.Castigator);
            else
                client.trimite(Protocol.Pierzator);

            client.ruleaza = false;
        }
    }

    public void next() {
        joc.next();
    }

    public boolean seJoaca() {
        return joc.seJoaca();
    }

    public boolean clientiPregatiti() {
        return clientiPregatiti;
    }

    public boolean jucatorATerminat() {
        return jucatorATerminat;
    }

    public int getCastigator() {
        return castigator;
    }

    public boolean verificaCastigator() {
        if (joc.getManaCurenta().eGol()) {
            castigator = joc.getNumarJucatorCurent();
            return true;
        } else {
            return false;
        }
    }

    public void updateClienti() {
        updateJucatorCurent();
        
        for (ServerThread client : clienti) {
            if (client.getPozitie() != joc.getNumarJucatorCurent()) {
                client.trimite(Protocol.Joaca);
            
                client.trimite(Protocol.RandulCeluilalt);
                
                for (ServerThread celalaltClient : clienti) {
                    if (celalaltClient.getPozitie() != client.getPozitie()) {
                        client.trimite(Protocol.Jucator);
                        
                        client.trimite(Protocol.Ordine);
                        client.trimiteObiect(celalaltClient.getPozitie());
                        
                        client.trimite(Protocol.NumarCarti);
                        client.trimiteObiect(joc.getMana(celalaltClient.getPozitie()).marime());

                        client.trimite(Protocol.SfarsitJucator);
                    }
                }
                client.trimite(Protocol.NiciunJucator);
                
                client.trimite(Protocol.Discard);
                client.trimiteObiect(joc.primaCarteDiscard());
            }
        }
    }
    
    public void updateJucatorCurent() {
        ServerThread client = clienti.get(joc.getNumarJucatorCurent());

        client.trimite(Protocol.Joaca);
        client.trimite(Protocol.Rand);

        for (ServerThread celalaltClient : clienti) {
            if (celalaltClient.getPozitie() != client.getPozitie()) {
                client.trimite(Protocol.Jucator);

                client.trimite(Protocol.Ordine);
                client.trimiteObiect(celalaltClient.getPozitie());

                client.trimite(Protocol.NumarCarti);
                client.trimiteObiect(joc.getMana(celalaltClient.getPozitie()).marime());

                client.trimite(Protocol.SfarsitJucator);
            }
        }
        client.trimite(Protocol.NiciunJucator);

        if (joc.primaCarteDiscard().getNumar() == Carte.Numar.DOI) {
            Carte card = joc.trageCarte();
            client.trimite(Protocol.Trage);
            client.trimiteObiect(card);

            card = joc.trageCarte();
            client.trimite(Protocol.Trage);
            client.trimiteObiect(card);
        } else if (joc.primaCarteDiscard().getNumar() == Carte.Numar.TREI) {
            Carte card = joc.trageCarte();
            client.trimite(Protocol.Trage);
            client.trimiteObiect(card);

            card = joc.trageCarte();
            client.trimite(Protocol.Trage);
            client.trimiteObiect(card);

            card = joc.trageCarte();
            client.trimite(Protocol.Trage);
            client.trimiteObiect(card);
        }

        while (! joc.sePoateJuca()) {
            Carte card = joc.trageCarte();
            client.trimite(Protocol.Trage);
            client.trimiteObiect(card);
            
            
          //  client.trimite(Protocol.RandulCeluilalt);            
          //  next();
            
        }

        client.trimite(Protocol.NuTrage);

        client.trimite(Protocol.Mana);
        client.trimiteObiect(joc.getManaCurenta().copiaza());

        Carte discard = joc.primaCarteDiscard();
        client.trimite(Protocol.Discard);
        client.trimiteObiect(discard);
        if(discard.getNumar() == Carte.Numar.AS) {
            client.trimite(Protocol.GetCuloareAs);
            client.trimiteObiect(joc.getSchimbaCuloare());
        }
        cereCarte();
    }

    private void cereCarte() {
        jucatorATerminat = false;

        final ServerThread client = clienti.get(joc.getNumarJucatorCurent());

        client.trimite(Protocol.CereCarte);
        
        new Thread() {
            @Override
            public void run() {
                client.primeste(Protocol.JoacaCartea);
                client.primesteObiect();
            }
        }.start();
    }

    private void carteAcceptata() {
        ServerThread client = clienti.get(joc.getNumarJucatorCurent());

        client.trimite(Protocol.Succes);

            jucatorATerminat = true;
    }
    
    private void primesteAs() {
        final ServerThread client = clienti.get(joc.getNumarJucatorCurent());
        
        client.trimite(Protocol.SetCuloareAs);
        
        new Thread() {
            @Override
            public void run() {
                client.primeste(Protocol.SetCuloareAs);
                client.primesteObiect();
            }
        }.start();
    }
    
    private void asAcceptat() {
        ServerThread client = clienti.get(joc.getNumarJucatorCurent());
        
        client.trimite(Protocol.Succes);
        
        jucatorATerminat = true;
    }



    public boolean verificaConexiuni() {
        if (clienti.size() < jucatori)
            return false;

        boolean totiConectati = true;
        for (Iterator<ServerThread> i = clienti.iterator(); i.hasNext();) {
            ServerThread client = i.next();
            if (!client.eConectat()) {
                i.remove();
                totiConectati = false;
            }
        }

        return totiConectati;
    }

  
    @Override
    public void mesajPrimit(PrimesteEvent event) {
        Mesaj mesaj = event.getMesaj();

        if (mesaj.getTip() == Mesaj.Tip.PROTOCOL) {
            String protocol = mesaj.getProtocol();
            if (protocol.equals(Protocol.Gata)) {
                if (verificaConexiuni()) {
                    for (ServerThread client : clienti)
                        if (! client.ePregatit())
                            return;

                    clientiPregatiti = true;
                    System.out.println(clientiPregatiti);
                }
            } else if (protocol.equals(Protocol.JoacaCartea)) {
                asteapta = Asteapta.CARTE;
            } else if (protocol.equals(Protocol.SetCuloareAs)) {
                asteapta = Asteapta.AS;
            }
        } else if (mesaj.getTip() == Mesaj.Tip.OBIECT) {
            if (asteapta == Asteapta.CARTE) {
                int card = ((Integer) mesaj.getObiect()).intValue();
                if (! joc.joacaCartea(card)) {
                    cereCarte();
                } else {
                    carteAcceptata();
                    asteapta = Asteapta.NIMIC;
                }
        } else if (asteapta == Asteapta.AS) {
            Carte.Culoare as = (Carte.Culoare) mesaj.getObiect();
            joc.setSchimbaCuloare(as);
            asAcceptat();
            asteapta = Asteapta.NIMIC;
        }
        } else {
            System.err.println("Mesaj necunscut primit: " + 
                               mesaj.getTip());
        }
    }
}
