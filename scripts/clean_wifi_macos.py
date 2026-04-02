import subprocess

WIFI_DEVICE = "en0"


def get_saved_network_names(device: str) -> list[str]:
    cmd = ["networksetup", "-listpreferredwirelessnetworks", device]
    output = subprocess.run(
        cmd,
        check=True,
        text=True,
        capture_output=True,
    ).stdout
    lines = output.splitlines()

    if len(lines) < 2:
        return []

    network_names = []
    for line in lines[1:]:
        network_name = line.strip()
        if network_name:
            network_names.append(network_name)

    return network_names


def select_network_names(network_names: list[str]) -> list[str]:
    for idx, network_name in enumerate(network_names, start=1):
        print(f"{idx:2d} {network_name}")

    print()
    raw = input("Enter one or more numbers to remove: ").strip()
    if not raw:
        return []

    selected_idxs: set[int] = set()
    for part in raw.split():
        if not part.isdigit():
            continue

        idx = int(part)
        if 1 <= idx <= len(network_names):
            selected_idxs.add(idx - 1)

    return [network_names[i] for i in sorted(selected_idxs)]


def remove_network_names(device: str, selected: list[str]) -> None:
    for name in selected:
        print(f"Removing: {name}")
        yes = input("Are you sure? (y/N) ").strip().lower()
        if yes != "y":
            print("Skipping...")
            continue

        cmd = ["sudo", "networksetup", "-removepreferredwirelessnetwork", device, name]
        subprocess.run(
            cmd,
            check=True,
        )


def main() -> None:
    network_names = get_saved_network_names(WIFI_DEVICE)
    if not network_names:
        return

    selected_network_names = select_network_names(network_names)
    if not selected_network_names:
        return

    remove_network_names(WIFI_DEVICE, selected_network_names)

    print("Done :D")


if __name__ == "__main__":
    main()
