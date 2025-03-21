
# 使用 linuxserver/chromium 作为基础镜像
FROM linuxserver/chromium:latest

# 设置环境变量，指定语言为中文
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# 安装 wget 和 gnupg
RUN apt-get update \
    && apt-get install -y wget gnupg

# 手动下载并导入公钥
RUN wget -qO - "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3B4FE6ACC0B21F32" | apt-key add - \
    && wget -qO - "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x871920D1991BC93C" | apt-key add -

# 备份原有的软件源列表
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

# 使用阿里云的软件源
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list

# 更新系统并安装中文语言包和字体
RUN apt-get update --fix-missing && apt-get install -y \
    language-pack-zh-hans \
    fonts-wqy-zenhei \
    && rm -rf /var/lib/apt/lists/*

# 创建目录并配置 Chrome 接受中文语言
RUN mkdir -p /config/chromium/Default \
    && echo '{ "intl": { "accept_languages": "zh-CN,zh" } }' > /config/chromium/Default/Preferences
