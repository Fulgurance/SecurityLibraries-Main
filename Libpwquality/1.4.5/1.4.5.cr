class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--with-securedir=/usr/lib/security",
                            "--with-python-binary=python3"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d")

        systemPasswordData = <<-CODE
        password  required    pam_pwquality.so   authtok_type=UNIX retry=1 difok=1 \
                                                 minlen=8 dcredit=0 ucredit=0 \
                                                 lcredit=0 ocredit=0 minclass=1 \
                                                 maxrepeat=0 maxsequence=0 \
                                                 maxclassrepeat=0 geoscheck=0 \
                                                 dictcheck=1 usercheck=1 \
                                                 enforcing=1 badwords="" \
                                                 dictpath=/usr/lib/cracklib/pw_dict
        password  required    pam_unix.so        yescrypt shadow try_first_pass
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/system-password",systemPasswordData)
    end

end
