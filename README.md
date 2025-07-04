# Subtitler

The subtitling app requires Swift packages for SwiftUI and Speech, which are built-in frameworks. It also requires a version equal to or newer to MacOS 11, iOS, and iPadOS 14. 

The subtitling app takes input from an audio file. It outputs an SRT file with a transcript of the spoken audio via the Swift Speech framework, recognising the audio input's speech. The video creator can then tweak this file to ensure complete accuracy of the subtitles without having to write all the subtitles themselves, providing a time and effort-saving solution compared to manually creating the subtitles from scratch. Generating an initial transcript that the video creator only needs to add timestamps to and correct errors makes the process much more efficient.

In the testing phase, the subtitles generated were 100% accurate to the test audio, recorded clearly into a microphone whilst speaking Standard British English in a southeast accent and using no technical terms or unusual words.

The subtitling app solves the problems with existing automatic subtitle-generating systems, such as the one employed by YouTube, as it reduces the time spent writing subtitles from scratch. However, it also bears in mind the complaints of the Deaf community that subtitle creation requires manual involvement. As a transcript is generated, video creators must edit the file for it to be usable, where any spotted errors can be corrected.

The software would be installable on iOS and iPadOS systems, and no attribution is needed to use subtitles generated by the subtitling app. The application is also installable on MacOS. However, it will be marked as 'Designed for iPad.'

To upload a file, click on 'choose audio file'. Then, click 'generate subtitles' to convert it to a text file. The transcript can then be saved to the device by clicking ‘save file’
