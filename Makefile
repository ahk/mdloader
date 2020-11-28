OUTNAME = mdloader
OBJDIR = build
CC = gcc
CFLAGS = -Wall -std=gnu99

ifeq ($(OS),Windows_NT)
CC = x86_64-w64-mingw32-gcc
endif

SRCFILES = mdloader_common.c mdloader_parser.c
ifeq ($(OS),Windows_NT)
SRCFILES += mdloader_win32.c
else
SRCFILES += mdloader_unix.c
endif

OBJFILES = $(patsubst %.c,%.o,$(SRCFILES))
OBJS = $(addprefix $(OBJDIR)/,$(OBJFILES))

all: $(OBJDIR)/$(OUTNAME)
	$(info Copying applets to ${OBJDIR}...)
	@cp applet-*.bin $(OBJDIR)
	$(info Done!)

$(OBJDIR)/$(OUTNAME): $(OBJS)
	$(info Creating $@...)
	@$(CC) $(CFLAGS) $(OBJS) -o $@
	@rm -f $(OBJDIR)/*.o

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@mkdir $(OBJDIR)

$(OBJS): $(OBJDIR)/%.o : %.c
	$(info Compiling ${<}...)
	@$(CC) $(CFLAGS) -c -o $@ $<

clean:
	$(info Removing $(OBJDIR)...)
	@rm -r -f $(OBJDIR)
	$(info Done!)
