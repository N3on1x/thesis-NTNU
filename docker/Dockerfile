FROM texlive/texlive:latest

WORKDIR /home/thesis-NTNU

RUN apt-get update && \
  apt install -qy gnuplot ghostscript && \
  # Cleanup
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean && \
  rm -rf /var/cache/apt/

ENTRYPOINT ["./docker/entrypoint.sh"]
