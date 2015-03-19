/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Client;

import java.io.*;
import java.net.*;

import java.util.List;
import java.util.ArrayList;

public class Client {

    private String host;
    private int port;

    private boolean conectat;
    private Socket socket;

    private List<ClientEventListener> listeners;

    private ObjectOutputStream socketObjOut;
    private ObjectInputStream socketObjIn;

    public Client() {
        this("localhost");
    }

    public Client(String host) {
        this(host, Protocol.PORT);
    }

    public Client(String host, int port) {
        this.host = host;
        this.port = port;

        conectat = false;

        socketObjOut = null;
        socketObjIn = null;

        listeners = new ArrayList<ClientEventListener>();
    }

    public boolean connect() {
        try {
            socket = new Socket(host, port);

            socketObjOut = new ObjectOutputStream(socket.getOutputStream());
            socketObjIn = new ObjectInputStream(socket.getInputStream());

            conectat = true;
            System.out.println("Conectat cu " + socket.getInetAddress());

        } catch (IOException eStream) {
            //
            try {
                socket.close();
            } catch (IOException eSocket) {
                //
            } finally {
                conectat = false;
            }
        } finally {
            return conectat;
        }
    }

    public void trimite(String protocol) {
        try {
            socketObjOut.writeObject(protocol);
            socketObjOut.flush();
        } catch (IOException e) {
            System.err.println("Eroare la trimiterea protocolului: " + protocol);
            e.printStackTrace();
            conectat = false;
        }

        System.out.println("TRIMIT:: " + protocol);
    }

    public void trimiteObiect(Object obiect) {
        try {
            socketObjOut.writeObject(obiect);
            socketObjOut.flush();
        } catch (IOException e) {
            System.err.println("Eroare la trimiterea obiectului: " + obiect);
            e.printStackTrace();
            conectat = false;
        }

        System.out.println("TRIMIT:: " + obiect);
    }

    private String citesteSocketInput() {
        String linie = null;

        try {
            linie = (String) socketObjIn.readObject();
        } catch (SocketException e) {
            System.err.println("Eroare socket.");
            e.printStackTrace();
            conectat = false;
        } catch (IOException e) {
            System.err.println("Eroare la citirea inputului.");
            e.printStackTrace();
            conectat = false;
        } catch (ClassNotFoundException e) {
            System.err.println("Nu se poate gasi clasa STRING");
            e.printStackTrace();
            conectat = false;
        }

        if (linie == null)
            conectat = false;


        System.out.println("PRIMESC:: " + linie);
        return linie;
    }


    private Object citesteSocketObjInput() {
        Object obiect = null;

        try {
            obiect = socketObjIn.readObject();
        } catch (SocketException e) {
            System.err.println("Eroare la citirea obiectului din socket");
            e.printStackTrace();
            conectat = false;
        } catch (IOException e) {
            System.err.println("Eroare la citirea obiectului");
            e.printStackTrace();
            conectat = false;
        } catch (ClassNotFoundException e) {
            System.err.println("Nu se poate gasi clasa obiectului");
            e.printStackTrace();
            conectat = false;
        }

        System.out.println("PRIMESC:: " + obiect);
        return obiect;
    }

    public void primeste(String protocol) {
        String linie = "";

        while (! linie.equals(protocol))
            linie = citesteSocketInput();

        trimiteMesajPrimit(linie);
    }

    public void primesteObiect() {
        Object obiect = citesteSocketObjInput();

        trimiteObiectPrimit(obiect);
    }

    public void primesteOptiuni(String protocolCorect, String protocolFals) {
        boolean trimis = false;
        while (! trimis) {
            String protocol = citesteSocketInput();
            if (protocol.equals(protocolCorect)) {
                trimiteMesajPrimit(protocolCorect);
                trimis = true;
            } else if (protocol.equals(protocolFals)) {
                trimiteMesajPrimit(protocolFals);
                trimis = true;
            }
        }
    }

    public void primesteSeJoaca() {
        primesteOptiuni(Protocol.Joaca, Protocol.Sfarsit);
    }

    public void primesteRand() {
        primesteOptiuni(Protocol.Rand, Protocol.RandulCeluilalt);
    }
    
    public void primesteTrage() {
        primesteOptiuni(Protocol.Trage, Protocol.NuTrage);
    }

    public void primesteCarteJucata() {
        primesteOptiuni(Protocol.Succes, Protocol.CereCarte);
    }

    public void primesteCastigator() {
        primesteOptiuni(Protocol.Castigator, Protocol.Pierzator);
    }

    public void primesteJucator() {
        primesteOptiuni(Protocol.Jucator, Protocol.NiciunJucator);
    }

    public void primesteUser() {
        primesteOptiuni(Protocol.User, Protocol.NiciunUser);
    }

    public void adaugaClientEventListener(ClientEventListener listener) {
        listeners.add(listener);
    }

    public void stergeClientEventListener(ClientEventListener listener) {
        listeners.remove(listener);
    }

    private void trimiteMesajPrimit(String protocol) {
        ClientEvent event = new ClientEvent(ClientEvent.PROTOCOL, protocol);
        for (ClientEventListener listener : listeners)
            listener.primesteActiuneCompleta(event);
    }

    private void trimiteObiectPrimit(Object obiect) {
        ClientEvent event = new ClientEvent(ClientEvent.OBIECT, obiect);
        for (ClientEventListener listener : listeners)
            listener.primesteObiectComplet(event);
    }

}
