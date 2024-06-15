class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                                  \
                                    --docdir=/usr/share/doc/gnutls-3.8.1                            \
                                    #{option("Libunistring") ? "" : "--with-included-unistring"}    \
                                    --with-default-trust-store-pkcs11=\"pkcs11:\"",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
