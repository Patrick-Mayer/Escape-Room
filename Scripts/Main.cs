using Godot;
using System;
using System.Runtime.CompilerServices;

public partial class Main : Node3D
{
	private XRInterface XR_Interface;

	public override void _Ready(){
		XRInterface XR_Interface = XRServer.FindInterface("OpenXR");
		if(XR_Interface != null && XR_Interface.IsInitialized()){
			Viewport viewport = GetViewport();
            DisplayServer.WindowSetVsyncMode(DisplayServer.VSyncMode.Disabled);
			viewport.UseXR = true;
		}else{
            GD.PrintErr("OpenXR isn't initialized. Fix your HMD connection.");
        }
	}
	
}
