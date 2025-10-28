loadAPI(19);

host.defineController("Novation", "LaunchControl XL (Macros)", "1.0", "B2F1E7F6-0001-0002-0003-B2F1E7F6C0DE", "svartfax");
host.defineMidiPorts(1, 1);
host.addDeviceNameBasedDiscoveryPair(["Launch Control XL"], ["Launch Control XL"]);

let macroControls = [];
let volumeControls = [];
var clipLaunchers = [];

function init() {
    host.getMidiInPort(0).setMidiCallback(onMidi);

    const trackBank = host.createTrackBank(8, 0, 2);
    for (let i = 0; i < 8; i++) {
        const track = trackBank.getChannel(i);

        // Access Clip controls
        var clipLauncher = track.clipLauncherSlotBank();
        clipLaunchers.push(clipLauncher);

        // Access Volume Controls
        const volume = track.volume();
        volume.setIndication(true);
        volumeControls.push(volume);

        // Access track-level remote controls
        const remoteControls = track.createCursorRemoteControlsPage(8);
        const macros = [];

        for (let j = 0; j < 3; j++) {
            const macro = remoteControls.getParameter(j);
            macro.setIndication(true);
            macros.push(macro);
        }

        macroControls.push(macros);
    }

    println("Track-level remote controls initialized.");
}

function onMidi(status, data1, data2) {
    var channel = status & 0x0F;
    var type = status & 0xF0;

    var isNoteOn = type === 0x90 && data2 > 0 && channel === 8; // MIDI channel 9

    if (isNoteOn) {
        println("Note On received: note=" + data1 + ", velocity=" + data2);

        // Notes 41 to 44 launch Scene 1 (slot 0)
        if (data1 >= 41 && data1 <= 44) {
            var trackIndex = data1 - 41;
            println("Launching Scene 1 clip on Track " + trackIndex);
            if (clipLaunchers[trackIndex]) {
                clipLaunchers[trackIndex].launch(0);
            }
        }

        // Notes 57 to 60 launch Scene 1 (slot 0)
        if (data1 >= 57 && data1 <= 60) {
            var trackIndex = data1 - 53;
            println("Launching Scene 1 clip on Track " + trackIndex);
            if (clipLaunchers[trackIndex]) {
                clipLaunchers[trackIndex].launch(0);
            }
        }

        // Notes 73 to 76 launch Scene 2 (slot 1)
        if (data1 >= 73 && data1 <= 76) {
            var trackIndex = data1 - 73;
            println("Launching Scene 2 clip on Track " + trackIndex);
            if (clipLaunchers[trackIndex]) {
                clipLaunchers[trackIndex].launch(1);
            }
        }

        // Notes 89 to 92 launch Scene 2 (slot 1)
        if (data1 >= 89 && data1 <= 92) {
            var trackIndex = data1 - 85;
            println("Launching Scene 2 clip on Track " + trackIndex);
            if (clipLaunchers[trackIndex]) {
                clipLaunchers[trackIndex].launch(1);
            }
        }
    }

    const isCC = (status & 0xF0) === 0xB0;
    if (!isCC) return;

    const cc = data1;
    const value = data2 / 127;

    let row = -1;
    let col = -1;

    if (cc >= 13 && cc <= 20) {
        row = 0;
        col = cc - 13;
    } else if (cc >= 29 && cc <= 36) {
        row = 1;
        col = cc - 29;
    } else if (cc >= 49 && cc <= 56) {
        row = 2;
        col = cc - 49;
    }

    // Handle macro controls
    if (row !== -1 && col !== -1 && macroControls[col] && macroControls[col][row]) {
        macroControls[col][row].set(value);
    } 
    // Volume Faders
    else if (cc >= 77 && cc <= 84) {
        const trackIndex = cc - 77;
        if (volumeControls[trackIndex]) {
            const scaledValue = value * 0.764;
            volumeControls[trackIndex].set(scaledValue);
        }
    }

}

function flush()
{
   // println("Flush called.");
}

function exit()
{
   println("Exited!");
}
