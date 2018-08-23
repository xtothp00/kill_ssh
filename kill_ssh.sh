#!/bin/sh

sshd_pids_no=0;
sshd_pids=$(pgrep --euid $(whoami) sshd);

echo "Found SSHD pids:";
echo "${sshd_pids}";

for i in ${sshd_pids}; do
   sshd_pids_no=$((${sshd_pids_no} + 1));
done

case ${sshd_pids_no} in
    0)
        echo "No SSHD process for user $(whoami) was found.";
        ;;
    1)
        echo "Only one SSHD process was found for user $(whoami)";
        ;;
    *)
        for i in ${sshd_pids}; do
            if [[ ${sshd_pids_no} -ne 1 ]]; then
                echo "Killing PID ${i}.";
                sudo kill $(pgrep --euid $(whoami) --oldest sshd);
            else
                echo "Remained PID $(pgrep --euid $(whoami) sshd)"
            fi;

            sshd_pids_no=$((${sshd_pids_no} - 1));
        done;
esac;

exit 0;
