class Target < ISM::Software

    def build
        super

        makeSource(["BUILD_OPT=1",
                    "NSPR_INCLUDE_DIR=/usr/include/nspr",
                    "USE_SYSTEM_ZLIB=1",
                    "ZLIB_LIBS=-lz",
                    "NSS_ENABLE_WERROR=0",
                    "USE_64=#{architecture("x86_64") ? "1" : "0"}",
                    "NSS_USE_SYSTEM_SQLITE=#{option("Sqlite") ? "1" : "0"}"],
                    buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/pkgconfig")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/include/nss")
        setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/include/nss",0o755)
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin")

        Dir["#{workDirectoryPath(false)}/dist/Linux*/lib/*.so"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/#{filename}"

            copyFile(filepath,destination)
            setPermissions(destination,0o755)
        end

        Dir["#{workDirectoryPath(false)}/dist/Linux*/lib/*.chk"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/#{filename}"

            copyFile(filepath,destination)
            setPermissions(destination,0o644)
        end

        copyFile(Dir["#{workDirectoryPath(false)}/dist/Linux*/lib/libcrmf.a"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/")
        setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/lib/libcrmf.a", 0o644)

        Dir["#{workDirectoryPath(false)}/dist/public/nss/*"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/include/nss/#{filename}"

            copyFile(filepath,destination)
            setPermissions(destination,0o644)
        end

        Dir["#{workDirectoryPath(false)}/dist/private/nss/*"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/include/nss/#{filename}"

            copyFile(filepath,destination)
            setPermissions(destination,0o644)
        end

        copyFile(Dir["#{workDirectoryPath(false)}/dist/Linux*/bin/certutil"],"#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/")
        setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/bin/certutil", 0o755)
    end

    def install
        super

        makeLink("../../../../nss/config/nss.pc","#{Ism.settings.rootPath}usr/lib/pkgconfig/nss.pc",:symbolicLinkByOverwrite)
        setPermissions("#{Ism.settings.rootPath}usr/lib/pkgconfig/nss.pc", 0o644)

        makeLink("../../../nss/config/nss-config","#{Ism.settings.rootPath}usr/bin/nss-config",:symbolicLinkByOverwrite)
        setPermissions("#{Ism.settings.rootPath}usr/bin/nss-config", 0o755)

        makeLink("../../../nss/config/nss-config","#{Ism.settings.rootPath}usr/bin/pk12util",:symbolicLinkByOverwrite)
        setPermissions("#{Ism.settings.rootPath}usr/bin/pk12util", 0o755)

        if option("P11-Kit")
            makeLink("./pkcs11/p11-kit-trust.so","#{Ism.settings.rootPath}usr/lib/libnssckbi.so",:symbolicLinkByOverwrite)
        end
    end

end
