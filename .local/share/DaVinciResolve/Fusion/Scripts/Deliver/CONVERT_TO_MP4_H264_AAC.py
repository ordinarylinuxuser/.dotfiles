import sys
import subprocess
import os
import math


def get_video_bitrate(file_path):
    """
    Extract the video stream's bit rate (in Mbps) using FFprobe and round it down.
    Returns `None` on errors.
    """
    cmd = [
        'ffprobe',
        '-v', 'error',
        '-select_streams', 'v:0',          # Select the first video stream
        '-show_entries', 'stream=bit_rate',
        '-of', 'default=noprint_wrappers=1:nokey=1',
        file_path
    ]
    try:
        output = subprocess.check_output(cmd, text=True).strip()
        if not output:
            print(f"No bitrate found for video stream in {file_path}")
            return None
        bit_rate_bps = int(output)         # Bit rate in bits per second
        bit_rate_mbps = bit_rate_bps / 1_000_000  # Convert to Mbps
        return math.floor(bit_rate_mbps)   # Round down to nearest integer
    except subprocess.CalledProcessError as e:
        print(f"FFprobe error: {e}")
        return None
    except ValueError:
        print(f"Could not parse bitrate from output: {output}")
        return None

def convert_with_ffmpeg(input_path):
    # Create output path with .mp4 extension
    output_path = os.path.splitext(input_path)[0] + ".mp4"
    
    bitrate = get_video_bitrate(input_path)
    
    bitrate = f"{bitrate}M" if bitrate else "30M"  # Default to 30 Mbps if bitrate is None
    print(f"Using video bitrate: {bitrate}")

    ffmpeg_command = [
        'ffmpeg',
        '-y',  # Overwrite output file if exists
        '-i', input_path,
        '-c:v', 'libx264',
        '-profile', 'high',
        '-b:v', bitrate,
        '-minrate', bitrate,
        '-maxrate', bitrate,
        '-bufsize', bitrate,
        '-x264-params', 'nal-hdr=cbr',
        '-c:a', 'aac',
        '-b:a', '320k',
        '-movflags', '+faststart',
        output_path
    ]
    
    try:
        subprocess.run(ffmpeg_command, check=True)
        print(f"Successfully converted to {output_path}")
        
        # Optional: Delete intermediate file
        os.remove(input_path)
        print(f"Deleted intermediate file: {input_path}")
        
    except subprocess.CalledProcessError as e:
        print(f"FFmpeg conversion failed: {str(e)}")
    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    
    job_detail = {
    "job_id": job, # its the unique job id
    "job_status": status, # its the job status
    "job_error": error # its the job error
    }
    
    script_path = os.path.dirname(sys.argv[0])
    
    if job_detail["job_status"] != "RenderCompleted":
        print("Job didn't complete successfully." + job_detail["job_error"])
        sys.exit(1)
    
    project = resolve.GetProjectManager().GetCurrentProject()

    # Find the job with jobid using next() (returns first match)
    job = next((j for j in project.GetRenderJobList() if j["JobId"] == job_detail["job_id"]), None)

    # Get the input file path from the job
    input_file = os.path.join(job["TargetDir"], job["OutputFilename"])

    print(f"Received rendered file: {input_file}")
   
    marker_script = os.path.join(script_path, "EXPORT_MARKERS_TO_CSV_YT_STAMPS.py")

    try:
        # Exporting markers to CSV
        result = subprocess.run([sys.executable, marker_script,"job_id",job_detail["job_id"]],capture_output=True, text=True)
        print(result.stdout)  # Print the output of the marker export
    except subprocess.CalledProcessError as e:
        print(f"Marker export failed: {str(e)}")
        sys.exit(1)

    convert_with_ffmpeg(input_file)
   