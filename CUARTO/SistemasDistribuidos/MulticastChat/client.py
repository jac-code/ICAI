import socket
import threading
import tkinter
from tkinter import font
import tkinter.scrolledtext
from tkinter import simpledialog

# aquí sería la IP publica
HOST = '127.0.0.1'
PORT = 6780

class Client:
    def __init__(self, host, port) -> None:
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # el cliente se conecta
        self.sock.connect((host, port))

        # cogemos el nombre de usuario
        msg = tkinter.Tk()
        msg.withdraw()

        self.username = simpledialog.askstring("Username", "Please put your username for the chat", parent=msg)

        self.gui_done = False
        self.running = True

        # hacemos uso de threads para montar la interfaz + gestionar conexiones con servidor
        gui_thread = threading.Thread(target=self.gui_loop)
        receive_thread = threading.Thread(target=self.receive)

        gui_thread.start()
        receive_thread.start()
    
    def gui_loop(self):
        self.win = tkinter.Tk()
        self.win.configure(bg="lightgray")

        self.chat_label = tkinter.Label(self.win, text="Chat:", bg="lightgray")
        self.chat_label.config(font=("Arial", 12))
        self.chat_label.pack(padx=20, pady=5)

        # textbox con todos los mensajes
        self.text_area = tkinter.scrolledtext.ScrolledText(self.win)
        self.text_area.pack(padx=20, pady=5)
        # asi el ususario no puede cambiar los mensajes
        self.text_area.config(state='disabled')

        self.message_label = tkinter.Label(self.win, text="Message:", bg="lightgray")
        self.message_label.config(font=("Arial", 12))
        self.message_label.pack(padx=20, pady=5)

        self.input_area = tkinter.Text(self.win, height=3)
        self.input_area.pack(padx=20, pady=5)

        self.send_button = tkinter.Button(self.win, text='Send', command=self.write)
        self.send_button.config(font=('Arial', 12))
        self.send_button.pack(padx=20, pady=5)

        # una vez que tenemos interfaz creada --> activamos
        self.gui_done = True

        self.win.protocol("WM_DELETE_WINDOW", self.stop)

        self.win.mainloop()

    def write(self):
        # cogemos el texto que hay en la barra de texto
        message = f"{self.username}: {self.input_area.get('1.0','end')}"
        self.sock.send(message.encode('utf-8'))
        self.input_area.delete('1.0', 'end')

    def stop(self):
        self.running = False
        self.win.destroy()
        self.sock.close()
        exit(0)
    
    def receive(self):
        while self.running:
            try:
                message = self.sock.recv(1024).decode('utf-8')
                if message == 'JAIME':
                    self.sock.send(self.username.encode('utf-8'))
                else:
                    if self.gui_done:
                        self.text_area.config(state='normal')
                        self.text_area.insert('end', message)
                        self.text_area.yview('end')
                        self.text_area.config(state='disabled')
            
            except ConnectionAbortedError:
                break
            except:
                print('An error ocurred')
                self.sock.close()
                break

client = Client(HOST, PORT)