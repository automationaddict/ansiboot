local REPO_URL = "https://github.com/automationaddict/ansible.git"

local function create_tmp_dir()
    -- Create the tmp directory
    local tmp_dir = "./tmp" -- Directory path

    print("Check if the directory exists and remove it")
    if os.execute("test -d " .. tmp_dir) then
        -- Remove the existing directory
        os.execute("rm -rf " .. tmp_dir)
    end

    print("Create the directory")
    if os.execute("mkdir -p " .. tmp_dir) then
        print(tmp_dir .. " directory has been created.")
    end
end

-- First run create tmp directory
create_tmp_dir()

-- Function to run a shell command and check its result
local function run_command(command)
    local output_file = "./tmp/setup_log.txt"
    local ok, exit_type, exit_code = os.execute(command .. " >> " .. output_file .. " 2>&1")
    -- print("Ok:", ok)
    -- print("Exit Type:", exit_type)
    -- print("Exit Code:", exit_code)
    if exit_code == 0 then
        return true
    end
    print("Command failed: " .. command)
    print("Check the log at " .. output_file .. " for details")
    return false
end

print("Updating, Upgrading, and Cleaning up the system")
-- Update package list
print("Updating package list")
run_command("sudo apt-get update -y")
print("Package list updated successfully")

-- Upgrade packages
print("Upgrading packages")
run_command("sudo apt-get upgrade -y")
print("Packages upgraded successfully")

-- Autoremove packages
print("Removing unused packages")
run_command("sudo apt-get autoremove -y")
print("Unused packages removed successfully")

-- Check if software-properties-common is installed
print("Checking if software-properties-common is installed")
if run_command("dpkg -l | grep -q software-properties-common") then
    print("software-properties-common is already installed")
else
    print("software-properties-common is not installed")
    if run_command("sudo apt-get install -y software-properties-common") then
        print("software-properties-common installed successfully")
    end
end

-- Check if ansible repository is present
print("Check if Ansible repository is present")
if run_command("grep -r '^deb .*ansible/ansible' /etc/apt/sources.list.d/") then
    print("Ansible repository is already present")
else
    print("Adding Ansible repository")
    if run_command("sudo apt-add-repository -y --update ppa:ansible/ansible") then
        print("Ansible repository has been added successfully")
    end
end

-- Check if Ansible is installed
print("Checking if Ansible is installed")
if run_command("dpkg -l | grep -q ansible") then
    print("Ansible is already installed")
else
    print("Ansible is not installed")
    if run_command("sudo apt-get install -y ansible") then
        print("Ansible has been installed successfully")
    end
end

-- Check if Python3 is installed
print("Checking if Python 3 is installed")
if run_command("dpkg -l | grep -q python3") then
    print("Python 3 is already installed")
else
    print("Python 3 is not installed")
    if run_command("sudo apt-get install -y python3") then
        print("Python 3 has been installed successfully")
    end
end

-- Check if Python3 Pip is installed
print("Checking if Python 3 Pip is installed")
if run_command("dpkg -l | grep -q python3-pip") then
    print("Python 3 Pip is already installed")
else
    print("Python 3 Pip is not installed")
    if run_command("sudo apt-get install -y python3-pip") then
        print("Python 3 Pip has been installed successfully")
    end
end

-- Check if Python3 Watchdog is installed
print("Checking if Python 3 Watchdog is installed")
if run_command("dpkg -l | grep -q python3-watchdog") then
    print("Python 3 Watchdog is already installed")
else
    print("Python 3 Watchdog is not installed")
    if run_command("sudo apt-get install -y python3-watchdog") then
        print("Python 3 Watchdog has been installed successfully")
    end
end

-- Check if python3 testresources is installed
print("Checking if Python 3 testresources is installed")
if run_command("dpkg -l | grep -q python3-testresources") then
    print("Python 3 testresources is already installed")
else
    print("Python 3 testresources is not installed")
    if run_command("sudo apt-get install -y python3-testresources") then
        print("Python 3 testresources has been installed successfully")
    end
end

-- Check if Python3 ArgComplete is installed
print("Checking if Python 3 ArgComplete is installed")
if run_command("dpkg -l | grep -q python3-argcomplete") then
    print("Python 3 ArgComplete is already installed")
else
    print("Python 3 ArgComplete is not installed")
    if run_command("sudo apt-get install -y python3-argcomplete") then
        print("Python 3 ArgComplete been installed successfully")
    end
end

-- Check if Python4 venv is installed
print("Checking if Python 3 venv is installed")
if run_command("dpkg -l | grep -q python3-venv") then
    print("Python 3 venv is already installed")
else
    print("Python 3 venv is not installed")
    if run_command("sudo apt-get install -y python3-venv") then
        print("Python 3 venv has been installed successfully")
    end
end

-- Ensure that the global Python 3 ArgComplete activation script is executed
print("Checking if activate-global-python-argcomplete3 has been executed")
if run_command("sudo activate-global-python-argcomplete3") then
    print("activate-global-python-argcomplete3 has been executed successfully")
end

-- Check if wkhtmltopdf is installed
print("Checking if wkhtmltopdf is installed")
if run_command("dpkg -l | grep -q wkhtmltopdf") then
    print("wkhtmltopdf is already installed")
else
    print("wkhtmltopdf is not installed")
    if run_command("sudo apt-get install -y wkhtmltopdf") then
        print("wkhtmltopdf has been installed successfully")
    end
end

-- Check if openSSH server is installed
print("Checking if OpenSSH server is installed")
if run_command("dpkg -l | grep -q openssh-server") then
    print("OpenSSH server is already installed")
else
    print("OpenSSH server is not installed")
    if run_command("sudo apt-get install -y openssh-server") then
        print("OpenSSH server has been installed successfully")
    end
end

-- Check if Just task runner is installed
print("Checking if Just task runner is installed")
if run_command("dpkg -l | grep -q just") then
    print("Just task runner is already installed")
else
    print("Just task runner is not installed")
    if run_command("sudo apt-get install -y just") then
        print("Just task runner has been installed successfully")
    end
end

-- Check if virtualbox is installed
print("Checking if VirtualBox is installed")
if run_command("dpkg -l | grep -q virtualbox") then
    print("VirtualBox is already installed")
else
    print("VirtualBox is not installed")
    if run_command("sudo apt-get install -y virtualbox") then
        print("VirtualBox has been installed successfully")
    end
end

-- Add Vagrant repository
print("Checking if Vagrant repository is present")
if run_command("grep -c '^deb .*hashicorp' /etc/apt/sources.list /etc/apt/sources.list.d/*") then
    print("Vagrant repository is already present")
else
    print("Adding Vagrant repository")
    run_command(
        "wget -qO - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg")
    run_command(
        "echo " ..
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" ..
        " | sudo tee /etc/apt/sources.list.d/hashicorp.list")
    print("Vagrant repository has been added successfully")
end

-- Update package list
print("Updating package list")
run_command("sudo apt-get update -y")
print("Package list updated successfully")

-- Check if Vagrant is installed
print("Checking if Vagrant is installed")
if run_command("dpkg -l | grep -q vagrant") then
    print("Vagrant is already installed")
else
    print("Vagrant is not installed")
    if run_command("sudo apt-get install -y vagrant") then
        print("Vagrant has been installed successfully")
    end
end

-- Clone the Ansible repository
print("Clone Ansible git repository")
local temp_dir = os.getenv("HOME") .. "/ansible.tmp/"
local target_dir = os.getenv("HOME") .. "/ansible/"

-- Clone the repository
if run_command("git clone " .. REPO_URL .. " " .. temp_dir) then
    create_tmp_dir()
    print("Ansible repository cloned successfully into " .. temp_dir)
end

-- Check if the directory exists
if run_command("test -d " .. target_dir) then
    print(temp_dir .. " already exists.")
    print("Do you want to overwrite the main directory? (yes/no): ")
    local answer = io.read()
    if answer == "yes" then
        print("Moving temp directory to target directory")
        run_command("rm -rf " .. target_dir)
        run_command("mv " .. temp_dir .. " " .. target_dir)
    else
        run_command("rm -rf " .. temp_dir)
        print("Exiting without overwriting the directory.")
        os.exit(1)
    end
else
    print("Creating target directory")
    run_command("mv -f " .. temp_dir .. " " .. target_dir)
    os.exit(1)
end
