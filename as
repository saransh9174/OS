import threading
import tkinter as tk
from tkinter import messagebox

def process1():
    global lock1, lock2, progress
    print("Process 1: Attempting to acquire Lock 1...")
    lock1.acquire()
    print(f"Process 1: Acquired Lock 1. Waiting for Lock 2...")
    lock2.acquire()
    print("Process 1: Acquired Lock 2")
    progress.append(1)  # Process 1 succeeded
    lock1.release()
    lock2.release()

def process2():
    global lock1, lock2, progress
    print("Process 2: Attempting to acquire Lock 2...")
    lock2.acquire()
    print(f"Process 2: Acquired Lock 2. Waiting for Lock 1...")
    lock1.acquire()
    print("Process 2: Acquired Lock 1")
    progress.append(2)  # Process 2 succeeded
    lock2.release()
    lock1.release()

def simulate_deadlock():
    global progress

    # Reset progress
    progress = []

    # Create two threads for process 1 and process 2
    thread1 = threading.Thread(target=process1)
    thread2 = threading.Thread(target=process2)

    thread1.start()
    thread2.start()

    thread1.join()
    thread2.join()

    if len(progress) == 2:
        messagebox.showinfo("Deadlock Detected", "Deadlock Detected! Click OK to resolve.")
        resolve_deadlock()
    else:
        messagebox.showinfo("No Deadlock", "No deadlock occurred.")

def resolve_deadlock():
    global lock2

    if lock2.locked():
        messagebox.showinfo("Deadlock Resolved", "Resolving deadlock by releasing Lock 2.")
        lock2.release()
        messagebox.showinfo("Deadlock Resolved", "Deadlock resolved by releasing Lock 2.")
    else:
        messagebox.showinfo("No Deadlock to Resolve", "No deadlock to resolve.")

# Initialize the GUI
root = tk.Tk()
root.title("Deadlock Simulation")

lock1 = threading.Lock()
lock2 = threading.Lock()
progress = []

# Create a button to start the deadlock simulation
start_button = tk.Button(root, text="Start Deadlock Simulation", command=simulate_deadlock)
start_button.pack(pady=10)

# Create a button to resolve the deadlock (only visible when deadlock is detected)
resolve_button = tk.Button(root, text="Resolve Deadlock", command=resolve_deadlock, state=tk.DISABLED)
resolve_button.pack(pady=10)

root.mainloop()
