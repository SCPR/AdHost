## AdHost

Preroll and Visual Ad Delivery for SCPR.

### ffmpeg
[FFMpeg](http://www.ffmpeg.org/) (2.13+) must be installed with fdkaac and lame.

On OS X, you can use Homebrew:

```bash
# lame is installed by default
brew install ffmpeg --with-fdk-aac
```

On Linux, you'll need to compile manually. See circle.yml for the step-by-step list that gets run on Circle CI to install ffmpeg.
