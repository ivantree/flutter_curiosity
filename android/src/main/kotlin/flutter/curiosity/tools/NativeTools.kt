package flutter.curiosity.toolsimport android.Manifestimport android.app.PendingIntentimport android.content.Contextimport android.content.Intentimport android.content.pm.PackageInfoimport android.content.res.Resourcesimport android.location.LocationManagerimport android.net.Uriimport android.os.Buildimport android.os.Processimport android.provider.Settingsimport androidx.core.content.FileProviderimport flutter.curiosity.CuriosityPlugin.Companion.activityimport flutter.curiosity.CuriosityPlugin.Companion.callimport flutter.curiosity.CuriosityPlugin.Companion.contextimport java.io.Fileimport kotlin.system.exitProcessobject NativeTools {    fun getBarHeight(barName: String?): Float {        val resources: Resources = context.resources        val resourceId = resources.getIdentifier(barName, "dimen", "android")        return resources.getDimensionPixelSize(resourceId).toFloat()    }    /**     * 安装apk     */    fun installApp(): String {        val apkPath = call.argument<String>("apkPath") ?: return Tools.resultError()        val file = File(apkPath)        val intent = Intent(Intent.ACTION_VIEW)        //版本在7.0以上是不能直接通过uri访问的        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) { //参数1 上下文, 参数2 Provider主机地址 和配置文件中保持一致   参数3  共享的文件            val apkUri = FileProvider.getUriForFile(context, context.packageName + ".provider", file)            //添加这一句表示对目标应用临时授权该Uri所代表的文件            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)            intent.setDataAndType(apkUri, "application/vnd.android.package-archive")        } else {            intent.setDataAndType(Uri.fromFile(file),                    "application/vnd.android.package-archive")        }        activity.startActivity(intent)        return Tools.resultSuccess()    }    /**     * 获取路径文件和文件夹大小     */    fun getFilePathSize(): String? {        val filePath = call.argument<String>("filePath") ?: return null        return if (FileTools.isDirectoryExist(filePath)) {            val file = File(filePath)            if (file.isDirectory) {                FileTools.getDirectorySize(file)            } else {                FileTools.getFileSize(file)            }        } else {            "NotFile"        }    }    /**     * 退出app     */    fun exitApp() {        //杀死进程，否则就算退出App，App处于空进程并未销毁，再次打开也不会初始化Application        //从而也不会执行getJSBundleFile去更换bundle的加载路径 !!!        Process.killProcess(Process.myPid())        exitProcess(0)    }    /**     * 判断手机是否安装某个应用     *     * @return true：安装，false：未安装 error 参数参数     */    fun isInstallApp(): Any {        val packageName = call.argument<String>("packageName") ?: Tools.resultError()        val packages: MutableList<PackageInfo> = context.packageManager.getInstalledPackages(0) // 获取所有已安装程序的包信息        for (packageInfo in packages) {            return packageName == packageInfo.packageName        }        return false    }    /**     * 跳转至应用商店     */    fun goToMarket(): String {        val packageName = call.argument<String>("packageName") ?: return Tools.resultError()        val marketPackageName = call.argument<String>("marketPackageName")                ?: return Tools.resultError()        val uri = Uri.parse("market://details?id=$packageName")        val intent = Intent(Intent.ACTION_VIEW, uri)        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)        if (marketPackageName != "") { // 如果没给市场的包名，则系统会弹出市场的列表让你进行选择。            intent.setPackage(marketPackageName)        }        activity.startActivity(intent)        return Tools.resultSuccess()    }    /**     * 拨打电话     */    fun callPhone(): String {        if (!Tools.checkPermission(Manifest.permission.CALL_PHONE)) return Tools.resultError("Lack of CALL_PHONE permissions")        val phoneNumber = call.argument<String>("phoneNumber")        val directDial = call.argument<Boolean>("directDial")        val intent = Intent()        if (directDial!!) {            intent.action = Intent.ACTION_CALL        } else {            intent.action = Intent.ACTION_DIAL        }        intent.data = Uri.parse("tel:$phoneNumber")        activity.startActivity(intent)        return Tools.resultSuccess()    }    /**     * 调用系统分享     */    fun systemShare(): String {        val type = call.argument<String>("type")        val title = call.argument<String>("title") ?: ""        val content = call.argument<String>("content")        val imagesPath = call.argument<ArrayList<String>>("imagesPath")        if (type != null) {            var shareIntent = Intent()            when (type) {                "text", "url" -> {                    if (content == null) {                        return Tools.resultError("not find text")                    }                    shareIntent.action = Intent.ACTION_SEND                    shareIntent.type = "text/plain"                    shareIntent.putExtra(Intent.EXTRA_TEXT, content)                }                "image" -> {                    if (content == null) {                        return Tools.resultError("not find image")                    }                    //将mipmap中图片转换成Uri                    val imgUri = Uri.parse(content)                    shareIntent.action = Intent.ACTION_SEND                    shareIntent.putExtra(Intent.EXTRA_STREAM, imgUri)                    shareIntent.type = "image/*"                }                "images" -> {                    if (imagesPath == null) {                        return Tools.resultError("not find imagesPath")                    }                    if (imagesPath.size == 0) {                        return Tools.resultError("imagesPath size is 0")                    }                    val imgUris = ArrayList<Uri>()                    for (value in imagesPath) {                        imgUris.add(Uri.parse(value))                    }                    shareIntent.action = Intent.ACTION_SEND_MULTIPLE                    shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)                    shareIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, imgUris)                    shareIntent.type = "image/*"                }            }            if (content != null || imagesPath != null) {                shareIntent = Intent.createChooser(shareIntent, title)                activity.startActivity(shareIntent)                return Tools.resultSuccess()            }            return Tools.resultError("not find text")        } else {            return Tools.resultError("not find type")        }    }    /**     * 跳转到设置页面让用户自己手动开启     */    fun jumpGPSSetting() {        val isOpen: Boolean = getGPSStatus() //判断GPS是否打开        if (!isOpen) {            val locationIntent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)            activity.startActivity(locationIntent)        }    }    /**     * 判断GPS是否开启，GPS或者AGPS开启一个就认为是开启的     * @return true 表示开启     */    fun getGPSStatus(): Boolean {        val locationManager: LocationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager        // 通过GPS卫星定位，定位级别可以精确到街（通过24颗卫星定位，在室外和空旷的地方定位准确、速度快）        val gps: Boolean = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)        // 通过WLAN或移动网络(3G/2G)确定的位置（也称作AGPS，辅助GPS定位。主要用于在室内或遮盖物（建筑群或茂密的深林等）密集的地方定位）        val network: Boolean = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)        return gps || network    }    /**     * 强制帮用户打开GPS     * 无效     */    fun open() {        val intent = Intent()        intent.setClassName("com.android.settings",                "com.android.settings.widget.SettingsAppWidgetProvider")        intent.addCategory("android.intent.category.ALTERNATIVE")        intent.data = Uri.parse("custom:3")        try {            PendingIntent.getBroadcast(context, 0, intent, 0).send()        } catch (e: PendingIntent.CanceledException) {            e.printStackTrace()        }    }}