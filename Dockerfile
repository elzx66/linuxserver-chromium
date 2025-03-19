
# 使用 linuxserver/chromium 作为基础镜像
FROM linuxserver/chromium:latest

# 设置环境变量，指定语言为中文
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# 备份原有的软件源列表
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

# 使用阿里云的软件源
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list

# 添加缺失的公钥
RUN apt-get update \
    && apt-get install -y gnupg \
    && gpg --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 871920D1991BC93C \
    && gpg --export --armor 3B4FE6ACC0B21F32 871920D1991BC93C | apt-key add -

# 更新系统并安装中文语言包和字体
RUN apt-get update --fix-missing && apt-get install -y \
    language-pack-zh-hans \
    fonts-wqy-zenhei \
    && rm -rf /var/lib/apt/lists/*

# 配置 Chrome 接受中文语言
RUN echo '{ "intl": { "accept_languages": "zh-CN,zh" } }' > /config/chromium/Default/Preferences
