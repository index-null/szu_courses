package udp;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MultithreadedUDPClients_C {

    private static final int LOCAL_PORT = 5003;
    private static final int REMOTE_PORT = 9999;
    private static final String TARGET_IP = "127.0.0.1";

    public static void main(String[] args) throws InterruptedException, SocketException {
        DatagramSocket socket = new DatagramSocket(LOCAL_PORT);

        ExecutorService executor = Executors.newFixedThreadPool(2);

        // Start the receiving thread
        executor.execute(new ReceiverThread(socket));

        // Start the sending thread
        executor.execute(new SenderThread(socket, TARGET_IP, REMOTE_PORT));

        // Keep the main thread alive until interrupted or manually stopped.
        Thread.currentThread().join();
    }

    static class ReceiverThread implements Runnable {
        private final DatagramSocket socket;

        ReceiverThread(DatagramSocket socket) {
            this.socket = socket;
        }

        @Override
        public void run() {
            while (true) {
                byte[] receiveBuffer = new byte[1024];
                DatagramPacket receivePacket = new DatagramPacket(receiveBuffer, receiveBuffer.length);

                try {
                    socket.receive(receivePacket);

                    String receivedMessage = new String(receivePacket.getData(), StandardCharsets.UTF_8).trim();
                    System.out.println(receivedMessage);
                } catch (IOException e) {
                    System.err.println("Error receiving message: " + e.getMessage());
                }
            }
        }
    }

    static class SenderThread implements Runnable {
        private final DatagramSocket socket;
        private final String targetIP;
        private final int targetPort;

        SenderThread(DatagramSocket socket, String targetIP, int targetPort) {
            this.socket = socket;
            this.targetIP = targetIP;
            this.targetPort = targetPort;
        }

        @Override
        public void run() {
            Scanner scanner = new Scanner(System.in);
            while (true) {
                // Simulate a message to be sent
                String message = "I am A";

                if (scanner.hasNextLine()){
                    message = scanner.nextLine();
                }

                try {
                    byte[] data = message.getBytes(StandardCharsets.UTF_8);
                    InetAddress targetAddress = InetAddress.getByName(targetIP);
                    DatagramPacket sendPacket = new DatagramPacket(data, data.length, targetAddress, targetPort);

                    socket.send(sendPacket);
                } catch (IOException e) {
                    System.err.println("Error sending message: " + e.getMessage());
                }

                // Add delay between messages for demonstration purposes (adjust as needed)
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        }
    }
}
