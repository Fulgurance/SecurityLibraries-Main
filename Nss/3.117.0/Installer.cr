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

    def deploy
        super

        [   "/usr/lib/libcrmf.a",
            "/usr/lib/pkgconfig/nss.pc",
            "/usr/lib/libcrmf.a",
            "/usr/lib/libfreebl3.chk",
            "/usr/lib/libfreebl3.so",
            "/usr/lib/libfreeblpriv3.chk",
            "/usr/lib/libfreeblpriv3.so",
            "/usr/lib/libnss3.so",
            "/usr/lib/libnssckbi-testlib.so",
            "/usr/lib/libnssdbm3.chk",
            "/usr/lib/libnssdbm3.so",
            "/usr/lib/libnsssysinit.so",
            "/usr/lib/libnssutil3.so",
            "/usr/lib/libsmime3.so",
            "/usr/lib/libsoftokn3.chk",
            "/usr/lib/libsoftokn3.so",
            "/usr/lib/libssl3.so"].each do |file|
            runChownCommand("root:root #{file}")
            runChmodCommand("644 #{file}")
        end
    end

end
