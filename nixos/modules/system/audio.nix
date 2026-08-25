{pkgs, ...}: {
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;

		extraLadspaPackages = with pkgs; [
			rnnoise-plugin
		];

		wireplumber.extraConfig."10-disable-suspend" = {
			"monitor.bluez.rules" = [
				{
					matches = [
						{"node.name" = "~bluez_input.*";}
						{"node.name" = "~bluez_output.*";}
					];
					actions = {
						update-props = {
							"session.suspend-timeout-seconds" = 0;
						};
					};
				}
			];
			"monitor.alsa.rules" = [
				{
					matches = [
						{"node.name" = "~alsa_input.*";}
						{"node.name" = "~alsa_output.*";}
					];
					actions = {
						update-props = {
							"session.suspend-timeout-seconds" = 0;
						};
					};
				}
			];
		};

		extraConfig.pipewire."20-virtual-sinks" = {
			"context.objects" = [
				{
					factory = "adapter";
					args = {
						"factory.name" = "support.null-audio-sink";
						"node.name" = "Virtual-Sink-OBS";
						"node.description" = "Virtual Sink for OBS";
						"media.class" = "Audio/Sink";
						"audio.position" = "FL,FR";
					};
				}
				{
					factory = "adapter";
					args = {
						"factory.name" = "support.null-audio-sink";
						"node.name" = "Virtual-Sink-Discord";
						"node.description" = "Virtual Sink for Discord";
						"media.class" = "Audio/Sink";
						"audio.position" = "FL,FR";
					};
				}
			];
		};

		extraConfig.pipewire."21-virtual-sinks-loopbacks" = {
			"context.modules" = [
				{
					name = "libpipewire-module-filter-chain";
					args = {
						"node.description" = "Noise Canceling Microphone";
						"media.name" = "Noise Canceling Microphone";
						"filter.graph" = {
							nodes = [
								{
									type = "ladspa";
									name = "rnnoise";
									plugin = "librnnoise_ladspa";
									label = "noise_suppressor_stereo";
									control = {
										"VAD Threshold (%)" = 50.0;
									};
								}
							];
						};
						"capture.props" = {
							"node.passive" = true;
						};
						"playback.props" = {
							"media.class" = "Audio/Source";
							"node.name" = "Virtual-Mic-Noise-Canceling";
							"audio.channels" = 2;
							"audio.position" = "FL,FR";
						};
					};
				}
				{
					name = "libpipewire-module-loopback";
					args = {
						"node.description" = "Loopback for Virtual Sink for OBS";
						"capture.props" = {
							"target.object" = "Virtual-Sink-OBS";
							"stream.capture.sink" = true;
						};
						"playback.props" = {
							"target.object" = "@DEFAULT_AUDIO_SINK@";
							"stream.dont-remix" = true;
							"node.passive" = true;
						};
					};
				}
				{
					name = "libpipewire-module-loopback";
					args = {
						"node.description" = "Loopback Discord";
						"capture.props" = {
							"target.object" = "Virtual-Sink-Discord";
							"stream.capture.sink" = true;
						};
						"playback.props" = {
							"target.object" = "@DEFAULT_AUDIO_SINK@";
							"node.passive" = true;
						};
					};
				}
				{
					name = "libpipewire-module-loopback";
					args = {
						"node.description" = "Discord Microphone Source";
						"capture.props" = {
							"target.object" = "Virtual-Sink-Discord";
							"stream.capture.sink" = true;
						};
						"playback.props" = {
							"media.class" = "Audio/Source";
							"node.name" = "Virtual-Mic-Discord";
							"audio.position" = "FL,FR";
						};
					};
				}
			];
		};

		extraConfig.pipewire."10-latency" = {
			"context.properties" = {
				"default.clock.rate" = 48000;
				"default.clock.quantum" = 512;
				"default.clock.min-quantum" = 512;
				"default.clock.max-quantum" = 512;
			};
		};

		extraConfig.pipewire-pulse."10-latency" = {
			"pulse.properties" = {
				"pulse.min.req" = "512/48000";
				"pulse.default.req" = "512/48000";
				"pulse.max.req" = "512/48000";
				"pulse.min.quantum" = "512/48000";
				"pulse.max.quantum" = "512/48000";
			};
			"stream.properties" = {
				"node.latency" = "512/48000";
				"resample.quality" = 1;
			};
		};
	};
}
