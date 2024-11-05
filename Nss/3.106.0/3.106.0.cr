class Target < ISM::Software

   def build
        super

        makeSource(arguments:   "BUILD_OPT=1                                            \
                                NSPR_INCLUDE_DIR=/usr/include/nspr                      \
                                USE_SYSTEM_ZLIB=1                                       \
                                ZLIB_LIBS=-lz                                           \
                                NSS_ENABLE_WERROR=0                                     \
                                USE_64=#{architecture("x86_64") ? "1" : "0"}            \
                                NSS_USE_SYSTEM_SQLITE=#{option("Sqlite") ? "1" : "0"}   \
                                NSS_DISABLE_GTESTS=1",
                path:           buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/pkgconfig")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/include/nss")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin")

        Dir["#{workDirectoryPathNoChroot}/dist/Linux*/lib/*.so"].each do |path|
            filepath = Ism.settings.rootPath != "/" ? path.sub(Ism.settings.rootPath,"") : path
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/#{filename}"

            copyFile(   filepath,
                        destination)
        end

        Dir["#{workDirectoryPathNoChroot}/dist/Linux*/lib/*.chk"].each do |path|
            filepath = Ism.settings.rootPath != "/" ? path.sub(Ism.settings.rootPath,"") : path
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/#{filename}"

            copyFile(   filepath,
                        destination)
        end

        copyFile(   "#{workDirectoryPath}/dist/Linux*/lib/libcrmf.a",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/")

        Dir["#{workDirectoryPathNoChroot}/dist/public/nss/*"].each do |path|
            filepath = Ism.settings.rootPath != "/" ? path.sub(Ism.settings.rootPath,"") : path
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/nss/#{filename}"

            copyFile(   filepath,
                        destination)
        end

        Dir["#{workDirectoryPathNoChroot}/dist/private/nss/*"].each do |path|
            filepath = Ism.settings.rootPath != "/" ? path.sub(Ism.settings.rootPath,"") : path
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/nss/#{filename}"

            copyFile(   filepath,
                        destination)
        end

        copyFile(   "#{workDirectoryPath}/dist/Linux*/bin/{certutil,pk12util}",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile(   "#{buildDirectoryPath}/config/nss-config",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/nss-config")

        copyFile(   "#{buildDirectoryPath}/config/nss.pc",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/pkgconfig/nss.pc")

        if option("P11-Kit")
            makeLink(   target: "./pkcs11/p11-kit-trust.so",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libnssckbi.so",
                        type:   :symbolicLinkByOverwrite)
        end
    end

    def install
        super

        runChmodCommand("0755 /usr/include/nss")
        runChmodCommand("0644 /usr/lib/libcrmf.a")
        runChmodCommand("0755 /usr/bin/certutil")
        runChmodCommand("0755 /usr/bin/nss-config")
        runChmodCommand("0755 /usr/bin/pk12util")

        runChmodCommand("0644 /usr/lib/pkgconfig/nss.pc")
        runChmodCommand("0644 /usr/lib/libcrmf.a")
        runChmodCommand("0644 /usr/lib/libfreebl3.chk")
        runChmodCommand("0644 /usr/lib/libfreebl3.so")
        runChmodCommand("0644 /usr/lib/libfreeblpriv3.chk")
        runChmodCommand("0644 /usr/lib/libfreeblpriv3.so")
        runChmodCommand("0644 /usr/lib/libnss3.so")
        runChmodCommand("0644 /usr/lib/libnssckbi-testlib.so")
        runChmodCommand("0644 /usr/lib/libnssdbm3.chk")
        runChmodCommand("0644 /usr/lib/libnssdbm3.so")
        runChmodCommand("0644 /usr/lib/libnsssysinit.so")
        runChmodCommand("0644 /usr/lib/libnssutil3.so")
        runChmodCommand("0644 /usr/lib/libsmime3.so")
        runChmodCommand("0644 /usr/lib/libsoftokn3.chk")
        runChmodCommand("0644 /usr/lib/libsoftokn3.so")
        runChmodCommand("0644 /usr/lib/libssl3.so")
    end

end
