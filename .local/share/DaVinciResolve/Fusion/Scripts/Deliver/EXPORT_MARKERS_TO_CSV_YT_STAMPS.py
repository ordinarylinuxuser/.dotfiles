import DaVinciResolveScript as dvr_script
import csv
import os
import sys

def add_leading_zeros(number):
    return f"{int(number):02d}"

def get_timecode_from_frame(pos, fps):
    seconds = pos / fps
    m = add_leading_zeros(int(seconds // 60))
    s = add_leading_zeros(int(seconds % 60))
    return f"{m}:{s}"

if __name__ == "__main__":
    resolve = dvr_script.scriptapp("Resolve")
    fusion = resolve.Fusion()
    project = resolve.GetProjectManager().GetCurrentProject()
    timeline = project.GetCurrentTimeline()
    markers = timeline.GetMarkers()

    job_id = sys.argv[2] if len(sys.argv) > 1 and sys.argv[1] == 'job_id' else job # pass from resolve if called from resolve

     # Find the job with jobid using next() (returns first match)
    job = next((j for j in project.GetRenderJobList() if j["JobId"] == job_id), None)

    # Get the input file path from the job
    output_dir = job["TargetDir"]

    # Get project name and create filename
    project_name = project.GetName()
    csv_filename = os.path.join(output_dir,f"{project_name.replace(' ', '_')}_TIMESTMAPS.csv")

    print(f"Exporting markers to {csv_filename}") 
    
    # Get frame rate and process markers
    framerate = float(project.GetSetting("timelineFrameRate"))
    positions = list(markers.keys())
    positions.sort()

   # Export to CSV
    with open(csv_filename, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Timecode", "Marker Name"])  # Header
        
        for pos in positions:
            marker = markers[pos]
            if marker["color"] == "Blue":
                timecode = get_timecode_from_frame(pos, framerate)
                writer.writerow([
                    timecode,
                    marker['name']
                ])

    print(f"Exported {len(positions)} markers to {csv_filename}")