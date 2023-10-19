import threading
import time

def process(progress, locks, process_id, request_sequence, event):
    print(f"Process {process_id}: Starting...")

    acquired_locks = []

    for lock_index in request_sequence:
        lock = locks[lock_index]
        if lock.acquire(blocking=False):
            acquired_locks.append(lock)
        else:
            for acquired_lock in acquired_locks:
                acquired_lock.release()
            print(f"Process {process_id}: Released acquired locks and waiting...")
            time.sleep(1)  # Simulate waiting
            return

    print(f"Process {process_id}: Acquired Locks {locks} in the order {request_sequence}")
    progress.append(process_id)

    if len(progress) == len(locks):
        event.set()

def main():
    num_processes = int(input("Enter the number of processes: "))

    if num_processes < 2:
        print("Please specify at least two processes for the deadlock resolution.")
        return

    num_locks = 2  # Number of available locks

    locks = [threading.Lock() for _ in range(num_locks)]
    progress = []
    deadlock_detected = threading.Event()

    threads = []

    # Create a circular waiting pattern
    request_sequences = [[0, 1], [1, 0]]

    for i in range(1, num_processes + 1):
        request_sequence = request_sequences[i % len(request_sequences)]
        thread = threading.Thread(target=process, args=(progress, locks, i, request_sequence, deadlock_detected))
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()

    if deadlock_detected.is_set():
        print("Deadlock Detected!")

        resolve = input("Do you want to resolve the deadlock by releasing a lock? (yes/no): ")
        if resolve.lower() == "yes":
            for lock in locks:
                if lock.locked():
                    print(f"Resolving deadlock by releasing Lock {locks.index(lock)}")
                    lock.release()
            print("Deadlock resolved by releasing locks.")
        else:
            print("No deadlock resolution attempted.")
    else:
        print("All processes have finished")

if __name__ == "__main__":
    main()
