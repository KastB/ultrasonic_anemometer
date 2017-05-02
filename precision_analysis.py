import matplotlib.pyplot as plt
import math
import numpy as np
import statistics

def deg2rad(d):
    return math.pi * d / 180.0


def rad2deg(r):
    return r * 180 / math.pi


def normalize_d(deg):
    while deg > 180.0:
        deg -= 360.0

    while deg < -180.0:
        deg += 360.0
    return deg


def normalize_r(rad):
    while rad > math.pi:
        rad -= 2 * math.pi

    while rad < -math.pi:
        rad += 2 * math.pi
    return rad


def denormalize_r(rad):
    rad = normalize_r(rad)
    if rad < 0:
        rad += 2 * math.pi
    return rad


def theta2vs(t):
    return 331.5 + 0.6 * t


def vw2dp(f, cal, vs, vw):
    p =  ((cal / (vs + vw) - cal / vs) * f)
    while p > 0.5:
        p = p - 1.0
    while p < -0.5:
        p = p + 1.0
    return p


def calculate(theta, cal1, cal2,cal3,cal4, f, p1r, p2r, p3r, p4r):
    vs = theta2vs(theta)
    v1 = cal1 / (cal1 / vs + p1r / f) - vs
    v2 = cal2 / (cal2 / vs + p2r / f) - vs
    v3 = cal3 / (cal3 / vs + p3r / f) - vs
    v4 = cal4 / (cal4 / vs + p4r / f) - vs

    sc2 = math.sqrt(v1 * v1 + v3 * v3)
    oc2 = math.atan2(v1, v3)
    sc3 = math.sqrt(v2 * v2 + v4 * v4)
    oc3 = math.atan2(v2, v4) + math.pi / 4.0
    oc  = math.atan2(math.sin(oc2) + math.sin(oc3), math.cos(oc2) + math.cos(oc3))

    sc = (sc2 + sc3) / 2.0
    return oc, sc, oc2, sc2, oc3, sc3

def main():
    plt.ylim([-5, 5])
    plt.xlim([-180, 180])

    x = []
    y1 = []
    y2 = []
    y3 = []
    y4 = []
    y5 = []
    y6 = []

    vs = 343.5
    theta = 20
    freq = 40000
    cal = 12.0 / freq * vs  # distance between transievers [m]
    samples = 1000
    phase_deviation = 1.0/2048
    temperature_deviation = 10.0
    calibration_deviation = 0.001
    frequency_deviation = 1000
    epsilon = 1.0/samples

    for o in range(-180, 180, 1):
        s = 5.0

        v1r = s * math.sin(deg2rad(o))
        v3r = s * math.cos(deg2rad(o))

        v2r = s * math.sin(deg2rad(o) - math.pi / 4)
        v4r = s * math.cos(deg2rad(o) - math.pi / 4)

        p1r_a = np.random.normal(vw2dp(freq, cal, vs, v1r), phase_deviation, samples)
        p2r_a = np.random.normal(vw2dp(freq, cal, vs, v2r), phase_deviation, samples)
        p3r_a = np.random.normal(vw2dp(freq, cal, vs, v3r), phase_deviation, samples)
        p4r_a = np.random.normal(vw2dp(freq, cal, vs, v4r), phase_deviation, samples)

        t_a = np.random.normal(theta, temperature_deviation, samples)
        d1_a = np.random.normal(cal, calibration_deviation, samples)
        d2_a = np.random.normal(cal, calibration_deviation, samples)
        d3_a = np.random.normal(cal, calibration_deviation, samples)
        d4_a = np.random.normal(cal, calibration_deviation, samples)
        f_a = np.random.normal(freq, frequency_deviation, samples)


        for i in range (0,len(p1r_a)):
            (oc, sc, oc2, sc2, oc3, sc3) = calculate(t_a[i], d1_a[i], d2_a[i], d3_a[i], d4_a[i], f_a[i], p1r_a[i], p2r_a[i], p3r_a[i], p4r_a[i])

            x.append(o + i * epsilon)
            y1.append(normalize_d(rad2deg(oc) - o))
            y2.append(sc - s)
            y3.append(normalize_d(rad2deg(oc2) - o))
            y4.append(sc2 - s)

            y5.append(normalize_d(rad2deg(oc3) - o))
            y6.append(sc3 - s)

    plt.plot(x, y1, '-')
    plt.plot(x, y2, 'r-')
    print ("orientation mean :" + str(statistics.mean(y1)))
    print ("orientation variance: " + str(statistics.variance(y1)))
    print("speed mean :" + str(statistics.mean(y2)))
    print("speed variance: " + str(statistics.variance(y2)))

    print ("")
    print ("single orientation mean :" + str(statistics.mean(y3)))
    print ("single orientation variance: " + str(statistics.variance(y3)))
    print("single speed mean :" + str(statistics.mean(y4)))
    print("single speed variance: " + str(statistics.variance(y4)))

    plt.show()


main()
