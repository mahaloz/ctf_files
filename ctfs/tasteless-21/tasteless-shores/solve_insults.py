from tqdm import tqdm
from sys import argv
from itertools import permutations

insults = {
"You fight like a dairy Farmer!":"How appropriate. You fight like a cow!",
"This is the END for you, you gutter crawling cur!":"And I've got a little TIP for you, get the POINT?",
"I've spoken with apes more polite than you!":"I'm glad to hear you attended your family reunion!",
"Soon you'll be wearing my sword like a shish kebab!":"First you'd better stop waving it like a feather duster.",
"People fall at my feet when they see me coming!":"Even BEFORE they smell your breath?",
"I'm not going to take your insolence sitting down!":"Your hemorrhoids are flaring up again eh?",
"I once owned a dog that was smarter than you.":"He must have taught you everything you know.",
"Nobody's ever drawn blood from me and nobody ever will.":"You run THAT fast?",
"Have you stopped wearing diapers yet?":"Why? Did you want to borrow one?",
"There are no words for how disgusting you are.":"Yes there are. You just never learned them.",
"You make me want to puke.":"You make me think somebody already did.",
"My handkerchief will wipe up your blood!":"So you got that job as janitor, after all.",
"I got this scar on my face during a mighty struggle!":"I hope now you've learned to stop picking your nose.",
"I've heard you are a contemptible sneak.":"Too bad no one's ever heard of YOU at all.",
"You're no match for my brains, you poor fool.":"I'd be in real trouble if you ever used them.",
"You have the manners of a beggar.":"I wanted to make sure you'd feel comfortable with me.",
"I beat the Sword Master!":"Are you still wearing this lousy shirt?",
"Now I know what filth and stupidity really are.":"I'm glad to hear you attended your family reunion.",
"Every word you say to me is stupid.":"I wanted to make sure you'd feel comfortable with me.",
"I've got a long, sharp lesson for you to learn today.":"And I've got a little TIP for you. Get the POINT?",
"I will milk every drop of blood from your body!":"How appropriate, you fight like a cow!",
"I've got the courage and skill of a master swordsman.":"I'd be in real trouble if you ever used them.",
"My tongue is sharper than any sword.":"First, you'd better stop waving it like a feather-duster.",
"My name is feared in every dirty corner of this island!":"So you got that job as a janitor, after all.",
"My wisest enemies run away at the first sight of me!":"Even BEFORE they smell your breath?",
"Only once have I met such a coward!":"He must have taught you everything you know.",
"If your brother's like you, better to marry a pig.":"You make me think somebody already did.",
"No one will ever catch ME fighting as badly as you do.":"You run THAT fast?",
"My last fight ended with my hands covered with blood.":"I hope now you've learned to stop picking your nose.",
"I hope you have a boat ready for a quick escape.":"Why, did you want to borrow one?",
"My sword is famous all over the Caribbean!":"Too bad no one's ever heard of YOU at all.",
"You are a pain in the backside, sir!":"Your hemorrhoids are flaring up again, eh?",
"I usually see people like you passed-out on tavern floors.":"Even BEFORE they smell your breath?",
"There are no clever moves that can help you now.":"Yes there are. You just never learned them.",
"Every enemy I've met I've annihilated!":"With your breath, I'm sure they all suffocated.",
"You're as repulsive as a monkey in a negligee.":"I look THAT much like your fiancée?",
"Killing you would be justifiable homicide!":"Then killing you must be justifiable fungicide.",
"You're the ugliest monster ever created!":" If you don't count all the ones you've dated.",
"I'll skewer you like a sow at a buffet!":"When I'm done with you, you'll be a boneless filet.",
"Would you like to be buried, or cremated?":"With you around, I'd prefer to be fumigated.",
"Coming face to face with me must leave you petrified!":"Is that your face? I thought it was your backside.",
"When your father first saw you, he must have been mortified!":"At least mine can be identified.",
"You can't match my witty repartee!":"I could, if you would use some breath spray.",
"I have never seen such clumsy swordplay!":"You would have, but you were always running away.",
"En garde! Touché!	Your mother wears a toupee!":"My skills with a sword are highly venerated!	Too bad they're all fabricated.",
"I can't rest 'til you've been exterminated!":"Then perhaps you should switch to decaffeinated.",
"I'll leave you devastated, mutilated, and perforated!":"Your odor alone makes me aggravated, agitated, and infuriated.",
"Heaven preserve me! You look like something that's died!":"The only way you'll be preserved is in formaldehyde.",
"I'll hound you night and day!":"Then be a good dog. Sit! Stay!",
"My attacks have left entire islands depopulated!":"With your breath, I'm sure they all suffocated.",
"You have the sex appeal of a Shar-Pei.":"I look THAT much like your fiancée?",
"When I'm done, your body will be rotted and putrified!":"Then killing you must be justifiable fungicide.",
"Your looks would make pigs nauseated.":"If you don't count all the ones you've dated.",
"Your lips look like they belong on catch of the day!":"When I'm done with you, you'll be a boneless filet.",
"I give you a choice. You can be gutted, or decapitated!":"With you around, I'd prefer to be fumigated.",
"Never before have I seen someone so sissified!":"Is that your face? I thought it was your backside.",
"You're a disgrace to your species, you're so undignified!":"At least mine can be identified.",
"Nothing can stop me from blowing you away!":"I could, if you would use some breath spray.",
"I have never lost to a melee!":"You would have, but you were always running away.",
"Your mother wears a toupee!":"Oh, that is so cliché.",
"My skills with a sword are highly venerated!":"Too bad they're all fabricated.",
"Your stench would make an outhouse cleaner irritated!":"Then perhaps you should switch to decaffeinated.",
"I can't tell you which of my traits leaves you most intimidated.":"Your odor alone makes me aggravated, agitated, and infuriated.",
"Nothing on this Earth can save your sorry hide!":"The only way you'll be preserved is in formaldehyde.",
"You'll find I am dogged and relentless to my prey!":"Then be a good dog. Sit! Stay!",
}


def reverse_lookup_insult(insult):
    # emulate scripting langs dict ordering
    #keys = sorted(list(insults.keys()))
    keys = list(insults.keys())

    key = keys.index(insult)
    return key

def lookup_insult(idx):
    #keys = sorted(list(insults.keys()))
    keys = list(insults.keys())
    insult = keys[idx]
    return insult

def convert_seq_to_words(seq):
    for s in seq:
        print(lookup_insult(s))

def dig(x, y, z, rot):
    hint = (x ^ (x << 4) & 0xff) & 0xff
    x = y
    y = z
    z = rot
    rot = z ^ hint ^ (z >> 1) ^ ((hint << 1) & 0xff)

    return rot % 64, (x, y, z, rot)

def get_nth_dig(x, y, z, rot, n):
    output = []
    for _ in range(n):
        out, point = dig(x, y, z, rot)
        x, y, z, rot = point
        output.append(out)

    return output

def solve(obs):
    # you need approximately 8 rounds to have a 50/50 chance
    round_sets = {i: {} for i in range(len(obs))}

    # initialize round 0 with a full 3 byte range
    rot = 0
    solns = {}
    for x in tqdm(range(0xff)):
        for y in range(0xff):
            for z in range(0xff):
                out, point = dig(x, y, z, rot)
                if out == obs[0] and point[2] == 0:
                    # nextround -> thisround
                    solns[point] = (x, y, z, rot)
    round_sets[0] = solns

    # run as many rounds as observations left
    for i in range(1, len(obs)):
        solns = {}
        for soln in tqdm(round_sets[i-1]):
            out, point = dig(*soln)
            if out == obs[i]:
                solns[point] = soln
        round_sets[i] = solns

    # use a backwards chain to verify the seed is real
    for k in tqdm(round_sets[len(round_sets)-1]):
        last_round = k
        for i in range(len(round_sets)-1,-1,1):
            if last_round in round_sets[i]:
                last_round = round_sets[i][last_round]
        else:
            print(f"[+] FOUND SEED: {last_round}")
            yield last_round


if __name__ == "__main__":
    observations = [
        "Heaven preserve me! You look like something that's died!",
        "This is the END for you, you gutter crawling cur!",
        "Killing you would be justifiable homicide!",
        "My tongue is sharper than any sword.",
        "My skills with a sword are highly venerated!",
        "My attacks have left entire islands depopulated!",
        "You're the ugliest monster ever created!",
        "I've heard you are a contemptible sneak.",
    ]
    idx_obs = []
    for obs in observations:
        idx_obs.append(reverse_lookup_insult(obs))

    #idx_obs = [53, 28, 51, 42, 16, 28, 55, 50]
    print("[+] Inverting and composing init state:")
    print(idx_obs)

    print("[+] Starting solve...")
    init_vals = solve(idx_obs)

    print("[+] Getting next sequence...")
    for init_val in init_vals:
        print("[+] Extended Sequence: ")
        print(get_nth_dig(*init_val, len(idx_obs)*2 + 30))

    # convert_seq_to_words(get_nth_dig(*init_val, len(idx_obs)*2 + 11)[len(idx_obs)+1:])
    import ipdb; ipdb.set_trace()
