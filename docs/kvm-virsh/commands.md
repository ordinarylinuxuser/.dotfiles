# KVM Virsh Commands

- List virtual machines

    ```sh
    virsh list --all --title
    ```

- List virtual machines which already have snapshots

    ```sh
    virsh list --all --title --with-snapshot
    ```

- List virtual machines which donlt have snapshots

    ```sh
    virsh list --all --title --without-snapshot
    ```

- Create Internal Snapshot with name

    ```sh
    virsh snapshot-create-as debian pkg-updated #vmname and then snapshot name
    ```

- List all snapshots for vm

    ```sh
    virsh snapshot-list debian
    virsh snapshot-list debian --topological
    virsh snapshot-list debian --tree
    virsh snapshot-list debian --leaves --topological  #leaf nodes
    virsh snapshot-list debian --no-leaves --topological #no leaf nodes,has children
    ```

- Info about a snapshot in vm

    ```sh
    virsh snapshot-info debian pkg-updated
    ```

- Determine current snapshot

    ```sh
    virsh snapshot-current debian --name
    ```

- Revert to a snapshot
  
    ```sh
    virsh snapshot-revert debian pkg-updated 
    virsh snapshot-revert debian pkg-updated --running # start after reverting
    ```

- Delete snapshots
  
    ```sh
    virsh snapshot-delete debian nginx # delete snapshot only
    virsh snapshot-delete debian desktop-live --children-only #keep snapshot but delete all childrens for snopshot
    virsh snapshot-delete debian desktop-live --children #delete snapshot and children
    ```
