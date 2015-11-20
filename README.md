# ZBModule-iOS2Arduino

iOS app to Arduino communication via LinkSprite's BLE Shield (http://learn.linksprite.com/arduino/shields/bluetooth-4-0-shield-for-arduino/) - a cheap BLE Shield you can find on TaoBao.

Couldn't find some good documentation for it. So here is a working example of code for both the iOS and Arduino parts.

## Note

The app will connect directly to the BLE Shield and to the right characteristic where data can be written to. I only tested it on one BLE Shield from LinkSprite so not sure all the names are same. In case it doesn't work, get the name of your shield as well as its Read/Write characteristic from the LightBlue application.
