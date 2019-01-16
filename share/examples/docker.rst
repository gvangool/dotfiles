Dockerfile snippets
===================
Snippets that can be added to a Dockerfile to force certain behavior (e.g.
during testing).

Set locale
----------
On Debian/Ubuntu

.. code:: Dockerfile

   RUN set -eu \
           && apt-get update \
           && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
           && rm -rf /var/lib/apt/lists/* \
           && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen  \
           && dpkg-reconfigure --frontend=noninteractive locales \
           && update-locale LANG=en_US.UTF-8
   ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

Set timezone
------------
On Debian, CentOS:

.. code:: Dockerfile

  ENV TZ=America/Vancouver
  RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

On Alpine, it's similar except that tzdata is not installed by default. That
gives you 2 options:

- add the tzdata package and keep it installed (adds 1.33MB):

  .. code:: Dockerfile

    ENV TZ=America/Vancouver
    RUN apk add --no-cache tzdata && \
        ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
        echo $TZ > /etc/timezone

- only copy the timezone to ``/etc/localtime`` (adds 0.03MB):

  .. code:: Dockerfile

    RUN set -eu \
          && TZ=America/Vancouver
          && apk add --no-cache tzdata \
          && cp /usr/share/zoneinfo/$TZ /etc/localtime \
          && echo $TZ > /etc/timezone \
          && apk del tzdata

  In this case it's important that the TZ environment variable is not set.
