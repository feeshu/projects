/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package Main;

import Client.Protocol;
import Server.Server;

public class ServerMain {

    public static void main(String[] args) throws InterruptedException {
        int jucatori = 2;

        int port = Protocol.PORT;

        Server server = new Server(port, jucatori);

        System.out.println("Serverul asteapta conexiuni");
        server.asculta();
        while (! server.verificaConexiuni())
            server.asculta();
        System.out.println("Serverul conectat la toti clientii.");

        while (! server.clientiPregatiti()) {
            System.out.println("astept");
            Thread.sleep(100);
        }

        System.out.println("Incepe jocul");
        server.start();

        while (server.seJoaca()) {
            server.updateClienti();
            System.out.println("Clienti updatati");

            while (! server.jucatorATerminat())
                Thread.sleep(100);

            if (server.verificaCastigator())
                server.jocIncheiat();
            else
                server.next();
        }

    }

}

