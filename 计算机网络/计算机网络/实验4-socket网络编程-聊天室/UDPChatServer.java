package udp;

import java.io.IOException;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UDPChatServer {

    private static final int SERVER_PORT = 9999;
    private static final String DISCONNECT_MESSAGE = "DISCONNECT";

    private final Map<InetSocketAddress, String> clients = new HashMap<>();

    private final DatagramSocket serverSocket;

    public UDPChatServer() throws SocketException {
        this.serverSocket = new DatagramSocket(SERVER_PORT);
        System.out.println("UDP Chat Server started on port " + SERVER_PORT);
    }

    public void start() {
        new Thread(() -> {
            while (true) {
                try {
                    byte[] buffer = new byte[1024];
                    DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
                    serverSocket.receive(packet);

                    String message = new String(packet.getData(), packet.getOffset(), packet.getLength(), StandardCharsets.UTF_8).trim();
                    InetSocketAddress sender = new InetSocketAddress(packet.getAddress(), packet.getPort());

                    if (!clients.containsKey(sender)) {
                        clients.put(sender, message);
                        broadcast("Server:" + clients.get(sender) + " is online", sender);
                        System.out.println("New client connected: " + sender + "(" + message + ")");
                    }else {
                        if (message.equals(DISCONNECT_MESSAGE)) {
                            clients.remove(sender);
                            System.out.println("Client disconnected: " + sender + "(" + message + ")");
                        } else {
                            broadcast(message, sender);
                        }
                    }


                } catch (IOException e) {
                    System.err.println("Error occurred in server loop: " + e.getMessage());
                }
            }
        }).start();
    }

    private void broadcast(String message, InetSocketAddress excludedSender) {
        for (Map.Entry<InetSocketAddress, String> entry : clients.entrySet()) {
            if (!entry.getKey().equals(excludedSender)) {
                sendToClient(message, entry, clients.get(excludedSender));
            }
        }
    }

    private void sendToClient(String message, Map.Entry<InetSocketAddress, String> client,String sender_name) {
        int isServermessage = 0;
        try {

            byte[] data;
            if (message.startsWith("Server:")){
                data = (message).getBytes(StandardCharsets.UTF_8);
                isServermessage = 1;
            }else {
                data = ("(" + sender_name + ")" + ":" + message).getBytes(StandardCharsets.UTF_8);
            }
            if (isServermessage == 0){
                System.out.println("(" + sender_name + ")" + ":" + message);
            }

            DatagramPacket packet = new DatagramPacket(data, data.length, client.getKey().getAddress(), client.getKey().getPort());
            serverSocket.send(packet);
        } catch (IOException e) {
            System.err.println("Failed to send message to client: " + client + ". Error: " + e.getMessage());
        }
    }

    public static void main(String[] args) throws SocketException {
        new UDPChatServer().start();
    }
}
