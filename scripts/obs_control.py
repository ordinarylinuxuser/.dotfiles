import argparse
from obsws_python import ReqClient

# This script provides a command-line interface to control OBS Studio using the obs-websocket plugin.
# It allows starting/stopping recording, switching scenes, and toggling source visibility.
# The script uses the obsws_python library to interact with OBS via WebSocket.
# The script requires the obs-websocket plugin to be installed and running in OBS Studio.
# The script can be run from the command line with various arguments to perform different actions.

# Install sudo pacman -S python-obsws

def handle_recording(cl, command):
    if command == 'start':
        cl.start_record()
        print("Recording started")
    elif command == 'stop':
        cl.stop_record()
        print("Recording stopped")
    elif command == 'toggle':
        cl.toggle_record_pause()
        print("Recording pause toggled")

def handle_visibility(cl, scene_name, source_name, show, hide,toggle):
    items = cl.get_scene_item_list(scene_name).scene_items
    item = next((i for i in items if i['sourceName'] == source_name), None)
    
    if not item:
        raise ValueError(f"Source '{source_name}' not found in scene '{scene_name}'")
    
    if toggle:
        # Get current visibility state
        current = cl.get_scene_item_enabled(scene_name, item['sceneItemId']).scene_item_enabled
        visible = not current
    else:
        visible = show  # If not toggling, use show/hide flags

    cl.set_scene_item_enabled(scene_name, item['sceneItemId'], visible)
    state = "visible" if visible else "hidden"
    print(f"Source '{source_name}' in scene '{scene_name}' set to {state}")

def main():
    parser = argparse.ArgumentParser(description="OBS Control Script")
    parser.add_argument('--host', default='localhost', help='OBS WebSocket host')
    parser.add_argument('--port', type=int, default=4455, help='OBS WebSocket port')
    parser.add_argument('--password', default='JvHTpZ4hJsfafiBQ', help='OBS WebSocket password')
    
    subparsers = parser.add_subparsers(dest='action', required=True, help='Action to perform')

    # Recording commands
    record_parser = subparsers.add_parser('record', help='Control recording')
    record_parser.add_argument('command', choices=['start', 'stop', 'toggle'], 
                             help='Recording action')

    # Scene commands
    scene_parser = subparsers.add_parser('scene', help='Control scenes')
    scene_parser.add_argument('--name', required=True, help='Scene name to switch to')

    # Source visibility commands
    vis_parser = subparsers.add_parser('visibility', help='Control source visibility')
    vis_parser.add_argument('--scene', required=True, help='Scene containing the source')
    vis_parser.add_argument('--source', required=True, help='Source name to modify')
    vis_parser.add_argument('--show', action='store_true', help='Make source visible')
    vis_parser.add_argument('--hide', action='store_true', help='Make source invisible')
    vis_parser.add_argument('--toggle', action='store_true', help='Toggle visibility state')

    args = parser.parse_args()

    try:
        # Connect to OBS
        with ReqClient(host=args.host, port=args.port, password=args.password, timeout=3) as cl:
            if args.action == 'record':
                handle_recording(cl, args.command)
            elif args.action == 'scene':
                cl.set_current_program_scene(args.name)
                print(f"Switched to scene: {args.name}")
            elif args.action == 'visibility':
                handle_visibility(cl, args.scene, args.source, args.show, args.hide,args.toggle)

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()