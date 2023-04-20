class Target < ISM::Software

    def configure
        super

        configureSource(["--prefix=/usr"],buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
        makeSource(["-C","doc","html"],buildDirectoryPath)
        runMakeinfoCommand(["--html","--no-split","-o","doc/gcrypt_nochunks.html","doc/gcrypt.texi"],buildDirectoryPath)
        runMakeinfoCommand(["--plaintext","-o","doc/gcrypt.txt","doc/gcrypt.texi"],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/html")

        copyFile("#{buildDirectoryPath(false)}doc/README","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/README")
        copyFile("#{buildDirectoryPath(false)}doc/README.apichanges","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/README.apichanges")
        copyFile(Dir["#{buildDirectoryPath(false)}doc/fips*"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/")
        copyFile(Dir["#{buildDirectoryPath(false)}doc/libgcrypt*"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/")
        copyFile(Dir["#{buildDirectoryPath(false)}doc/gcrypt.html/*"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/html/")
        copyFile("#{buildDirectoryPath(false)}doc/gcrypt_nochunks.html","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/gcrypt_nochunks.html")
        copyFile("#{buildDirectoryPath(false)}doc/gcrypt.txt","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/gcrypt.txt")
        copyFile("#{buildDirectoryPath(false)}doc/gcrypt.texi","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/gcrypt.texi")
    end

    def install
        super

        #setPermissions("#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4",0o755)
        #setPermissions("#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/html",0o755)
        #setPermissions("#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/README",0o644)
        #setPermissions("#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/README.apichanges",0o644)
        #setPermissions(Dir["#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/fips*"],0o644)
        #setPermissions(Dir["#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/libgcrypt*"],0o644)
        #setPermissions(Dir["#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/html/*"],0o644)
        #setPermissions("#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/gcrypt_nochunks.html",0o644)
        #setPermissions("#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/gcrypt.txt",0o644)
        #setPermissions("#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/gcrypt.texi",0o644)
        exit 1
    end

end
