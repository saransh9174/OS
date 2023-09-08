#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

struct Process {
    int id;
    int burstTime;
    int priority;
    int waitingTime;
    int turnaroundTime;
    int completionTime;
};

bool comparePriority(const Process &a, const Process &b) {
    return a.priority < b.priority;
}

int main() {
    int numProcesses;

    cout << "Enter the number of processes: ";
    cin >> numProcesses;

    vector<Process> processes(numProcesses);

    for (int i = 0; i < numProcesses; ++i) {
        processes[i].id = i + 1;
        cout << "Enter burst time for process " << i + 1 << ": ";
        cin >> processes[i].burstTime;
        cout << "Enter priority for process " << i + 1 << ": ";
        cin >> processes[i].priority;
    }

    // Sort processes based on priority (in ascending order)
    sort(processes.begin(), processes.end(), comparePriority);

    int currentTime = 0;
    double totalWaitingTime = 0;

    cout << "Process execution order: ";
    for (int i = 0; i < numProcesses; ++i) {
        cout << processes[i].id << " ";

        processes[i].waitingTime = currentTime;
        currentTime += processes[i].burstTime;
        processes[i].turnaroundTime = currentTime - processes[i].waitingTime;
        processes[i].completionTime = currentTime;

        totalWaitingTime += processes[i].waitingTime;
    }

    double averageWaitingTime = totalWaitingTime / numProcesses;
    cout << "\nAverage Waiting Time: " << averageWaitingTime << endl;

    cout << "Process\tBurst Time\tPriority\tCompletion Time\tTurnaround Time\tWaiting Time\n";
    for (int i = 0; i < numProcesses; ++i) {
        cout << processes[i].id << "\t" << processes[i].burstTime << "\t\t" << processes[i].priority << "\t\t"
             << processes[i].completionTime << "\t\t" << processes[i].turnaroundTime << "\t\t" << processes[i].waitingTime << endl;
    }

    return 0;
}