@echo off
net use J: /DELETE /y
net use X: /DELETE /y
net use Y: /DELETE /y
net use Z: /DELETE /y

net use X: \\AS4002T-A6F7\Music /user:admin asdf1242
net use Y: \\AS4002T-A6F7\Media 
net use Z: \\AS4002T-A6F7\Home
net use J: \\AS4002T-A6F7\Docker  